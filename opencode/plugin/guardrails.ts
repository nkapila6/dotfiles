import type { Plugin } from "@opencode-ai/plugin"

export type GuardrailsOptions = {
  enabled?: boolean
  rules?: {
    commitHygiene?: boolean
    noPip?: boolean
    noDepChanges?: boolean
    noDelete?: boolean
    noCiCd?: boolean
    noCommitExplained?: boolean
    noEmoji?: boolean
  }
  allowDepFiles?: string[]
  allowCiFiles?: string[]
}

// --- Constants ---

const CONVENTIONAL_COMMIT_RE =
  /^(feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert|bump)(\(.+\))?: .+/

const AI_ATTRIBUTION_RE = /Co-authored-by:|Generated with|\u00a9/

// Covers common emoji Unicode ranges: emoticons, pictographs, transport,
// dingbats, variation selectors, flags, misc symbols, arrows.
const EMOJI_RE =
  /[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{1F700}-\u{1F77F}\u{1F900}-\u{1F9FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{FE00}-\u{FE0F}\u{1F1E6}-\u{1F1FF}\u{1F018}-\u{1F270}\u{231A}-\u{23FF}\u{2B00}-\u{2BFF}]/u

const DEP_MANIFEST_FILES = [
  "package.json",
  "package-lock.json",
  "bun.lock",
  "bun.lockb",
  "go.mod",
  "go.sum",
  "requirements.txt",
  "Pipfile",
  "pyproject.toml",
  "Cargo.toml",
  "Gemfile",
  "Gemfile.lock",
  "composer.json",
]

const CI_CD_BASENAMES = [
  ".gitlab-ci.yml",
  "Jenkinsfile",
  "azure-pipelines.yml",
  ".drone.yml",
  "cloudbuild.yaml",
  "cloudbuild.yml",
  "Makefile",
  "Dockerfile",
  "docker-compose.yml",
  "docker-compose.yaml",
  ".dockerignore",
  "turbo.json",
  "nx.json",
  "vercel.json",
  "netlify.toml",
  "fly.toml",
  "render.yaml",
  "Procfile",
  "deploy.sh",
]

const CI_CD_PATH_CONTAINS = [".github/workflows/", ".circleci/", "deploy/"]

const CI_CD_BASENAME_GLOBS = [
  "webpack.config.*",
  "vite.config.*",
  "rollup.config.*",
  "esbuild.config.*",
  ".eslintrc*",
  ".prettierrc*",
  "biome.json*",
  "scripts/deploy*",
]

// Patterns that are safe to delete (build artifacts, temp files).
const BUILD_ARTIFACT_PATTERNS = [
  "node_modules/",
  "dist/",
  "build/",
  ".cache/",
  "tmp/",
  ".log",
]

// --- Helpers ---

/** Split a shell command on &&, ||, ;, and newlines into sub-commands. */
function splitCommands(command: string): string[] {
  return command
    .split(/\s*(?:&&|\|\||;)\s*/)
    .flatMap((c) => c.split(/\n+/))
    .map((c) => c.trim())
    .filter(Boolean)
}

/**
 * Extract commit messages from -m and --message flags.
 * Handles: -m "msg", -m 'msg', -am "msg", --message="msg", --message "msg".
 */
function extractCommitMessages(command: string): string[] {
  const messages: string[] = []
  const regex = /(?:--message(?:=|\s+)|-[a-zA-Z]*m)\s*(?:"([^"]*)"|'([^']*)'|(\S+))/g
  let match: RegExpExecArray | null
  while ((match = regex.exec(command)) !== null) {
    messages.push(match[1] || match[2] || match[3] || "")
  }
  return messages
}

/** Check if a path target is a build artifact (safe to delete). */
function isBuildArtifact(target: string): boolean {
  return BUILD_ARTIFACT_PATTERNS.some((p) => {
    if (p.startsWith(".")) return target.endsWith(p)
    return target.includes(p) || target === p.replace(/\/$/, "")
  })
}

/** Get the basename from a file path (cross-platform). */
function fileBasename(filePath: string): string {
  return filePath.replace(/\\/g, "/").split("/").pop() || filePath
}

/** Check if a file path matches CI/CD config patterns. */
function matchesCiCd(filePath: string, allowCiFiles: string[]): boolean {
  const normalized = filePath.replace(/\\/g, "/")
  const basename = fileBasename(normalized)

  // tsconfig.json is local config, not a project build config.
  if (basename === "tsconfig.json") return false

  if (allowCiFiles.some((a) => normalized.endsWith(a) || basename === a))
    return false

  if (CI_CD_BASENAMES.includes(basename)) return true
  if (CI_CD_PATH_CONTAINS.some((p) => normalized.includes(p))) return true

  return CI_CD_BASENAME_GLOBS.some((g) => {
    const re = new RegExp(
      "^" + g.replace(/\./g, "\\.").replace(/\*/g, ".*") + "$",
    )
    return re.test(basename) || re.test(normalized)
  })
}

// --- Rule checkers (return error string or null) ---

function checkCommitHygiene(command: string): string | null {
  if (!/\bgit\s+commit\b/.test(command)) return null

  const messages = extractCommitMessages(command)
  if (messages.length === 0) return null // no -m flags, using editor

  // Multiple -m flags = body present.
  if (messages.length > 1)
    return "Blocked: commit body is not allowed. Subject line only."

  const fullMessage = messages[0]

  // Blank line followed by more text = body present.
  if (/\n\s*\n\S/.test(fullMessage))
    return "Blocked: commit body is not allowed. Subject line only."

  if (AI_ATTRIBUTION_RE.test(fullMessage))
    return "Blocked: AI attribution in commit message. Remove Co-authored-by/Generated lines."

  if (EMOJI_RE.test(fullMessage))
    return "Blocked: emoji in commit message."

  const subject = fullMessage.split("\n")[0].trim()
  if (!CONVENTIONAL_COMMIT_RE.test(subject))
    return `Blocked: commit message does not follow Conventional Commits. Expected "type(scope): description" in lowercase.`

  return null
}

function checkNoPip(command: string): string | null {
  if (/\b(pip3?|python\s+-m\s+pip)\s+install\b/.test(command))
    return "Blocked: use uv instead of pip. Replace pip install with uv pip install or uv add."
  return null
}

function checkNoDepChangesBash(command: string): string | null {
  const BLOCK_MSG =
    "Blocked: adding/removing dependencies requires human approval. Ask first."

  // Commands that always add packages.
  if (/\b(yarn\s+add|bun\s+add|go\s+get|cargo\s+add|uv\s+add|gem\s+install)\b/.test(command))
    return BLOCK_MSG

  // npm/yarn/bun install: only block if a package name is present.
  // Check each sub-command independently to avoid false positives on chained commands.
  for (const sub of splitCommands(command)) {
    for (const cmd of ["npm install", "npm i", "yarn install", "bun install"]) {
      const re = new RegExp(`\\b${cmd.replace(/\s+/g, "\\s+")}\\b`)
      const match = sub.match(re)
      if (!match) continue
      const after = sub.slice(match.index! + match[0].length).trim()
      const args = after.split(/\s+/).filter((a) => a && !a.startsWith("-"))
      if (args.length > 0) return BLOCK_MSG
    }
  }

  return null
}

function checkNoDelete(command: string): string | null {
  const subCommands = splitCommands(command)
  for (const sub of subCommands) {
    if (!/\b(rm|rmdir|unlink)\b/.test(sub)) continue

    // If the sub-command doesn't start with rm/rmdir/unlink, we can't
    // safely parse targets. Block conservatively.
    if (!/^\s*(rm|rmdir|unlink)\b/.test(sub))
      return "Blocked: file deletion requires human approval. Ask first."

    const parts = sub.split(/\s+/)
    const targets = parts.slice(1).filter((a) => !a.startsWith("-"))
    if (targets.length === 0) continue

    // Allow if every target is a build artifact.
    if (targets.every(isBuildArtifact)) continue

    return "Blocked: file deletion requires human approval. Ask first."
  }
  return null
}

function checkNoCommitExplained(command: string): string | null {
  if (!/\bgit\s+add\b/.test(command)) return null

  // Find args after "git add", skip flags.
  const idx = command.search(/\bgit\s+add\b/)
  if (idx === -1) return null
  const rest = command.slice(idx).replace(/^git\s+add\s*/, "")
  const args = rest.split(/\s+/).filter((a) => a && !a.startsWith("-"))

  if (args.some((a) => a === "explained" || a.startsWith("explained/")))
    return "Blocked: do not stage the explained/ folder. It should stay untracked."

  return null
}

function checkNoEmojiInContent(
  tool: string,
  args: Record<string, unknown>,
): string | null {
  let content: string | undefined
  if (tool === "edit") content = args.newString as string | undefined
  if (tool === "write") content = args.content as string | undefined
  if (typeof content !== "string") return null

  if (EMOJI_RE.test(content))
    return "Blocked: no emojis in code/files. Remove emoji characters."

  return null
}

function checkNoDepChangesFile(
  filePath: string,
  allowDepFiles: string[],
): string | null {
  const basename = fileBasename(filePath)
  if (allowDepFiles.some((a) => filePath.endsWith(a) || basename === a))
    return null
  if (DEP_MANIFEST_FILES.some((f) => basename === f || filePath.endsWith("/" + f)))
    return `Blocked: editing dependency manifest ${basename} requires human approval. Ask first.`
  return null
}

function checkNoCiCdFile(
  filePath: string,
  allowCiFiles: string[],
): string | null {
  if (matchesCiCd(filePath, allowCiFiles))
    return `Blocked: editing CI/CD config ${fileBasename(filePath)} requires human approval. Ask first.`
  return null
}

// --- Plugin export ---

export default (async ({ directory }, options = {}) => {
  const opts = options as GuardrailsOptions
  if (opts.enabled === false) return {}

  const rules = opts.rules ?? {}
  const allowDepFiles = opts.allowDepFiles ?? []
  const allowCiFiles = opts.allowCiFiles ?? []

  const enabled = (key: keyof NonNullable<GuardrailsOptions["rules"]>) =>
    rules[key] !== false

  return {
    "tool.execute.before": async (input, output) => {
      try {
        const args = (output?.args ?? {}) as Record<string, unknown>

        if (input.tool === "bash") {
          const command = args.command
          if (typeof command !== "string") return

          const checks: Array<[() => boolean, () => string | null]> = [
            [() => enabled("commitHygiene"), () => checkCommitHygiene(command)],
            [() => enabled("noPip"), () => checkNoPip(command)],
            [() => enabled("noDepChanges"), () => checkNoDepChangesBash(command)],
            [() => enabled("noDelete"), () => checkNoDelete(command)],
            [
              () => enabled("noCommitExplained"),
              () => checkNoCommitExplained(command),
            ],
          ]

          for (const [isOn, check] of checks) {
            if (!isOn()) continue
            const error = check()
            if (error) throw new Error(error)
          }
        }

        if (input.tool === "edit" || input.tool === "write") {
          const filePath = args.filePath
          if (typeof filePath !== "string") return

          if (enabled("noEmoji")) {
            const error = checkNoEmojiInContent(input.tool, args)
            if (error) throw new Error(error)
          }

          if (enabled("noDepChanges")) {
            const error = checkNoDepChangesFile(filePath, allowDepFiles)
            if (error) throw new Error(error)
          }

          if (enabled("noCiCd")) {
            const error = checkNoCiCdFile(filePath, allowCiFiles)
            if (error) throw new Error(error)
          }
        }
      } catch (err) {
        // Re-throw Blocked errors, swallow everything else (fail-open).
        if (err instanceof Error && err.message.startsWith("Blocked:")) throw err
      }
    },
  }
}) satisfies Plugin

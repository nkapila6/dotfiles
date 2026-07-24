import path from "node:path"
import os from "node:os"
import type { Plugin } from "@opencode-ai/plugin"

export type SafeguardOptions = {
  patterns?: string[]
  paths?: string[]
  allow?: string[]
  enabled?: boolean
}

const DEFAULT_PATTERNS: string[] = [
  // Environment files
  ".env",
  ".env.*",

  // SSH private keys (public keys are fine)
  "id_rsa",
  "id_dsa",
  "id_ecdsa",
  "id_ed25519",

  // Crypto / cert material
  "*.pem",
  "*.key",
  "*.p12",
  "*.pfx",
  "*.keystore",
  "*.jks",

  // Cloud credentials
  "credentials.json",
  "credentials.*.json",
  "service-account*.json",

  // Token-bearing config files
  ".npmrc",
  ".pypirc",
  ".netrc",
  ".htpasswd",
  "oauth_token",
  "access_tokens.db",
  "token.json",

  // Secret manifests
  "secrets.yaml",
  "secrets.yml",
  "secrets.json",
  "secrets.toml",
  "secrets.ini",
]

const DEFAULT_PATHS: string[] = [
  ".aws/credentials",
  "~/.aws/credentials",
  ".gnupg/",
  ".ssh/*",
]

// Public SSH artifacts we should not block.
const SSH_ALLOWLIST = ["*.pub", "known_hosts", "authorized_keys"]

// This plugin only guards the `read` tool and `read` permissions.
// It does not block shell reads because that is an open-ended exfiltration surface.

function globToRegex(pattern: string): RegExp {
  let re = "^"
  for (let i = 0; i < pattern.length; i++) {
    const c = pattern[i]
    if (c === "*") {
      if (pattern[i + 1] === "*") {
        re += ".*"
        i++
      } else {
        re += "[^/]*"
      }
    } else if (c === "?") {
      re += "[^/]"
    } else if (c === ".") {
      re += "\\."
    } else if (/[\\^$+?.|()[\]{}]/.test(c)) {
      re += `\\${c}`
    } else {
      re += c
    }
  }
  re += "$"
  return new RegExp(re, "i")
}

function normalizePath(raw: string, baseDir: string): string {
  let p = raw.replace(/\\/g, "/")
  if (p.startsWith("~")) {
    p = path.join(os.homedir(), p.slice(1))
  }
  p = path.resolve(baseDir, p)
  return path.normalize(p).replace(/\\/g, "/")
}

function matchPattern(pattern: string, fullPath: string, basename: string): boolean {
  if (pattern.includes("/")) {
    // Match as a path suffix: pattern .aws/credentials should match
    // /Users/x/.aws/credentials and also /.aws/credentials
    const regex = globToRegex(pattern)
    // Try exact match first (relative paths already normalized could match)
    if (regex.test(fullPath)) return true
    // Try as suffix with a path separator boundary
    const suffixRegex = new RegExp("(?:^|/)" + regex.source.slice(1), "i")
    if (suffixRegex.test(fullPath)) return true
    return false
  }
  const regex = globToRegex(path.basename(pattern))
  return regex.test(basename)
}

function isSensitive(
  rawPath: string,
  baseDir: string,
  patterns: string[],
  pathMatches: string[],
  allowPatterns: string[],
): { sensitive: true; pattern: string } | { sensitive: false } {
  const fullPath = normalizePath(rawPath, baseDir)
  const basename = path.basename(fullPath)

  if (isAllowed(fullPath, basename, allowPatterns)) {
    return { sensitive: false }
  }

  // SSH allowlist applies regardless of deny patterns.
  if (fullPath.includes("/.ssh/") && SSH_ALLOWLIST.some((p) => matchPattern(p, fullPath, basename))) {
    return { sensitive: false }
  }

  for (const pattern of patterns) {
    if (matchPattern(pattern, fullPath, basename)) {
      return { sensitive: true, pattern }
    }
  }

  for (const p of pathMatches) {
    if (fullPath.toLowerCase().includes(p.toLowerCase())) {
      return { sensitive: true, pattern: p }
    }
  }

  return { sensitive: false }
}

function isAllowed(fullPath: string, basename: string, allowPatterns: string[]): boolean {
  return allowPatterns.some((p) => matchPattern(p, fullPath, basename))
}

function extractPaths(input: string | string[] | undefined): string[] {
  if (!input) return []
  return Array.isArray(input) ? input : [input]
}

export default (async ({ directory }, options = {}) => {
  const opts = options as SafeguardOptions
  if (opts.enabled === false) {
    return {}
  }

  const patterns = [...DEFAULT_PATTERNS, ...(opts.patterns ?? [])]
  const pathMatches = [...DEFAULT_PATHS, ...(opts.paths ?? [])]
  const allowPatterns = opts.allow ?? []

  function check(pathStr: string): { sensitive: true; pattern: string } | { sensitive: false } {
    return isSensitive(pathStr, directory, patterns, pathMatches, allowPatterns)
  }

  return {
    "permission.ask": async (input, output) => {
      if (input.type !== "read") return
      const paths = extractPaths(input.pattern)
      for (const p of paths) {
        const result = check(p)
        if (result.sensitive) {
          output.status = "deny"
          return
        }
      }
    },

    "tool.execute.before": async (input, output) => {
      if (input.tool !== "read") return
      try {
        const args = output?.args ?? {}
        const rawPath = args.filePath
        if (typeof rawPath !== "string") return
        const result = check(rawPath)
        if (result.sensitive) {
          throw new Error(
            `Blocked: refusing to read sensitive file "${rawPath}" (matched pattern "${result.pattern}")`,
          )
        }
      } catch (err) {
        if (err instanceof Error && err.message.startsWith("Blocked:")) {
          throw err
        }
        // Defensive: ignore unexpected shapes and let the tool proceed.
      }
    },
  }
}) satisfies Plugin

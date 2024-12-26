#!/usr/bin/env node

const fs = require("fs")
const path = require("path")

try {
  const commonPath = path.join(
    __dirname,
    "..",
    "Cerys-Moon-of-Fulgora",
    "common.lua",
  )
  const content = fs.readFileSync(commonPath, "utf8")

  if (content.match(/DEBUG_\w+ = true/)) {
    console.error("Error: Debug flags must be disabled before publishing.")
    console.error("Please set all DEBUG_ variables to false in common.lua")
    process.exit(1)
  }
} catch (error) {
  console.error("Error checking debug flags:", error)
  process.exit(1)
}

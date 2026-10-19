/**
 * JSON string literal decoding that preserves LaTeX backslash commands.
 * Standard JSON.parse interprets \t, \f, \n, etc. as control characters.
 */

export type JsonStringDecodeMode = "latex" | "standard";

export interface DecodedJsonString {
  value: string;
  endIndex: number;
}

const latexNewlineMacroSuffixes = [
  "abla",
  "eq",
  "u",
  "ot",
  "mid",
  "less",
  "gtr",
] as const;

/** TeX commands that start with `\t` (JSON `\t` must not become TAB + suffix). */
const latexTabMacroSuffixes = [
  "extbf",
  "extit",
  "extnormal",
  "extrm",
  "riangle",
  "frac",
  "ext",
  "imes",
  "heta",
  "ilde",
  "au",
  "an",
  "o",
] as const;

/** Collapses JSON-style double backslashes before TeX commands (\\frac → \frac). */
const doubleEscapedMacro = /\\\\([A-Za-z]+)/g;

export function normalizeDoubleEscapedLatex(text: string): string {
  let out = text;
  while (doubleEscapedMacro.test(out)) {
    doubleEscapedMacro.lastIndex = 0;
    out = out.replace(doubleEscapedMacro, "\\$1");
  }
  return out;
}

/**
 * Reverses JSON `\t` corruption inside LaTeX (TAB + `ext{` → `\text{`, etc.).
 * Apply to Gemini `part.text` before [parseAiChatGeminiJson].
 */
export function repairTabCorruptedLatex(text: string): string {
  if (!text.includes("\t")) return text;

  const out: string[] = [];
  let i = 0;
  while (i < text.length) {
    if (text[i] === "\t") {
      const rest = text.slice(i + 1);
      const suffix = latexTabMacroSuffixes.find((s) => rest.startsWith(s));
      if (suffix != null) {
        out.push("\\t", suffix);
        i += 1 + suffix.length;
        continue;
      }
    }
    out.push(text[i]);
    i++;
  }
  return out.join("");
}

export function decodeJsonStringLiteral(
  source: string,
  startIndex: number,
  mode: JsonStringDecodeMode,
): DecodedJsonString | null {
  if (source[startIndex] !== "\"") return null;

  let i = startIndex + 1;
  let out = "";

  while (i < source.length) {
    const ch = source[i];
    if (ch === "\"") {
      return {value: out, endIndex: i + 1};
    }

    if (ch !== "\\") {
      out += ch;
      i++;
      continue;
    }

    i++;
    if (i >= source.length) return null;
    const esc = source[i];

    if (mode === "standard") {
      const decoded = decodeStandardEscape(source, i, esc);
      if (decoded == null) return null;
      out += decoded.value;
      i = decoded.endIndex;
      continue;
    }

    switch (esc) {
    case "\"":
      out += "\"";
      i++;
      break;
    case "\\":
      out += "\\";
      i++;
      break;
    case "/":
      out += "/";
      i++;
      break;
    case "b":
      out += "\\";
      out += "b";
      i++;
      break;
    case "f":
      out += "\\";
      out += "f";
      i++;
      break;
    case "r":
      out += "\\";
      out += "r";
      i++;
      break;
    case "t":
      out += "\\";
      out += "t";
      i++;
      break;
    case "n": {
      const rest = source.slice(i + 1);
      const macroSuffix = latexNewlineMacroSuffixes.find((suffix) => rest.startsWith(suffix));
      if (macroSuffix != null) {
        out += "\\";
        out += "n";
        out += macroSuffix;
        i += 1 + macroSuffix.length;
      } else {
        out += "\n";
        i++;
      }
      break;
    }
    default: {
      const unicode = tryDecodeUnicodeEscape(source, i, esc);
      if (unicode != null) {
        out += unicode.value;
        i = unicode.endIndex;
        break;
      }
      out += "\\";
      out += esc;
      i++;
      break;
    }
    }
  }

  return null;
}

function decodeStandardEscape(
  source: string,
  index: number,
  esc: string,
): {value: string; endIndex: number} | null {
  switch (esc) {
  case "\"":
    return {value: "\"", endIndex: index + 1};
  case "\\":
    return {value: "\\", endIndex: index + 1};
  case "/":
    return {value: "/", endIndex: index + 1};
  case "b":
    return {value: "\b", endIndex: index + 1};
  case "f":
    return {value: "\f", endIndex: index + 1};
  case "n":
    return {value: "\n", endIndex: index + 1};
  case "r":
    return {value: "\r", endIndex: index + 1};
  case "t":
    return {value: "\t", endIndex: index + 1};
  default: {
    const unicode = tryDecodeUnicodeEscape(source, index, esc);
    if (unicode != null) return unicode;
    return {value: esc, endIndex: index + 1};
  }
  }
}

function tryDecodeUnicodeEscape(
  source: string,
  index: number,
  esc: string,
): {value: string; endIndex: number} | null {
  if (esc !== "u") return null;
  if (index + 4 >= source.length) return null;

  const hex = source.slice(index + 1, index + 5);
  if (!/^[0-9a-fA-F]{4}$/.test(hex)) return null;

  return {
    value: String.fromCharCode(parseInt(hex, 16)),
    endIndex: index + 5,
  };
}

export function skipWhitespace(source: string, startIndex: number): number {
  let i = startIndex;
  while (i < source.length && /\s/.test(source[i])) {
    i++;
  }
  return i;
}

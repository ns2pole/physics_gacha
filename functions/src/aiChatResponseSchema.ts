export const aiChatResponseSchema = {
  type: "object",
  properties: {
    text: {
      type: "string",
      description: "The assistant reply shown to the student (Markdown/LaTeX allowed).",
    },
    quickReplies: {
      type: "array",
      description: "0-5 suggested follow-up questions as tappable chips.",
      items: {
        type: "object",
        properties: {
          label: {
            type: "string",
            description: "Short chip label without LaTeX (under ~40 chars).",
          },
          sendText: {
            type: "string",
            description: "Optional fuller question sent when the chip is tapped.",
          },
          actionId: {
            type: "string",
            description: "Optional machine-readable action id.",
          },
        },
        required: ["label"],
      },
    },
  },
  required: ["text", "quickReplies"],
};

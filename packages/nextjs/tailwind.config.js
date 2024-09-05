/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./app/**/*.{js,ts,jsx,tsx}", "./components/**/*.{js,ts,jsx,tsx}", "./utils/**/*.{js,ts,jsx,tsx}"],
  plugins: [require("daisyui")],
  darkTheme: "dark",
  darkMode: ["selector", "[data-theme='dark']"],
  // DaisyUI theme colors
  daisyui: {
    themes: [
      {
        light: {
          primary: "#A8D5BA",          // Soft pastel green
          "primary-content": "#2C4A3E", // Darker green for contrast
          secondary: "#E8F4ED",        // Very light pastel green
          "secondary-content": "#2C4A3E",
          accent: "#7FB69E",           // Muted green accent
          "accent-content": "#FFFFFF",
          neutral: "#4A6D5D",          // Muted dark green
          "neutral-content": "#FFFFFF",
          "base-100": "#FFFFFF",
          "base-200": "#F7FAF9",       // Very light green tint
          "base-300": "#E8F4ED",       // Same as secondary
          "base-content": "#2C4A3E",
          info: "#A8D5BA",             // Same as primary
          success: "#8ECDA8",          // Pastel success green
          warning: "#F0E6AA",          // Pastel warning yellow
          error: "#E6B8B0",            // Pastel error red

          "--rounded-btn": "9999rem",

          ".tooltip": {
            "--tooltip-tail": "6px",
          },
          ".link": {
            textUnderlineOffset: "2px",
          },
          ".link:hover": {
            opacity: "80%",
          },
        },
      },
      {
        dark: {
          primary: "#7FB69E",          // Muted green
          "primary-content": "#FFFFFF",
          secondary: "#4A6D5D",        // Darker muted green
          "secondary-content": "#FFFFFF",
          accent: "#A8D5BA",           // Soft pastel green
          "accent-content": "#2C4A3E",
          neutral: "#E8F4ED",
          "neutral-content": "#2C4A3E",
          "base-100": "#2C4A3E",       // Dark muted green
          "base-200": "#3A5F50",       // Slightly lighter dark green
          "base-300": "#4A6D5D",       // Same as secondary
          "base-content": "#E8F4ED",
          info: "#7FB69E",             // Same as primary
          success: "#8ECDA8",          // Pastel success green
          warning: "#F0E6AA",          // Pastel warning yellow
          error: "#E6B8B0",            // Pastel error red

          "--rounded-btn": "9999rem",

          ".tooltip": {
            "--tooltip-tail": "6px",
            "--tooltip-color": "oklch(var(--p))",
          },
          ".link": {
            textUnderlineOffset: "2px",
          },
          ".link:hover": {
            opacity: "80%",
          },
        },
      },
    ],
  },
  theme: {
    extend: {
      boxShadow: {
        center: "0 0 12px -2px rgb(0 0 0 / 0.05)",
      },
      animation: {
        "pulse-fast": "pulse 1s cubic-bezier(0.4, 0, 0.6, 1) infinite",
      },
    },
  },
};

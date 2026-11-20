import type { Answer, Result, Sources } from "./app.contract.d.ts";

export const grants = "";

const FEATURES = [
  {
    id: "routing",
    title: "Tabs & Stack Navigation",
    subtitle: "Persistent tab stacks with URL sync and modal sheets",
    summary:
      "Exact maps each tab and nested route directly to platform navigation: URLs on the web, UIKit navigation stacks on iOS, and native modal sheets.",
  },
  {
    id: "forma",
    title: "Themes & Color Presets",
    subtitle: "System / Light / Dark + Custom Blue & Deep Purple",
    summary:
      "Appearance switches between system, light, and dark via setScheme(), while app.forma axes swap Custom Blue and Deep Purple brand tokens at runtime.",
  },
  {
    id: "content",
    title: "Native Controls & exact:content",
    subtitle: "SummaryCard, StatBar, grouped lists, switches, and alerts",
    summary:
      "Contract declares what each control is instead of rebuilding platform chrome. Buttons, switches, grouped lists, and alerts render natively per host.",
  },
];

const sources: Sources = {
  loadFeatures: () => FEATURES,
  signInCheck: ([email, password]): Result<"signInCheck"> => {
    const cleanEmail = email.trim();
    if (!cleanEmail) {
      return { ok: false, error: "Please enter your email.", name: "" };
    }
    if (!cleanEmail.includes("@")) {
      return {
        ok: false,
        error: "Please enter a valid email address.",
        name: "",
      };
    }
    if (password.length < 4) {
      return {
        ok: false,
        error: "Password must be at least 4 characters.",
        name: "",
      };
    }
    return { ok: true, error: "", name: "User Profile" };
  },
};

export const answer: Answer = (source, args, store, storage, native) =>
  sources[source](args, store, storage, native);

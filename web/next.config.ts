import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  transpilePackages: ["@kurolabs/web", "@questify/web", "@omoi/web"],
};

export default nextConfig;

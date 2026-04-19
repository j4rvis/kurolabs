import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  transpilePackages: ["@kurolabs/web", "@questify/web"],
};

export default nextConfig;

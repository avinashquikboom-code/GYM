import type { Metadata } from "next";
import { Montserrat, Oswald } from "next/font/google";
import "./globals.css";
import Providers from "@/components/providers";

const montserrat = Montserrat({
  variable: "--font-montserrat",
  subsets: ["latin"],
  weight: ["400", "500", "600", "700"],
});

const oswald = Oswald({
  variable: "--font-oswald",
  subsets: ["latin"],
  weight: ["500", "600", "700"],
});

export const metadata: Metadata = {
  title: "GYM - Executive Admin Center",
  description: "Enterprise SaaS Gym Administration Console",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html
      lang="en"
      className={`${montserrat.variable} ${oswald.variable} h-full antialiased dark`}
      style={{
        fontFamily: "var(--font-montserrat), sans-serif",
      }}
    >
      <body className="min-h-full flex flex-col bg-[#0E0F12] text-white">
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}

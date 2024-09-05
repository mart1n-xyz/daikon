import React from "react";
import { hardhat } from "viem/chains";
import { SwitchTheme } from "~~/components/SwitchTheme";
import { useTargetNetwork } from "~~/hooks/scaffold-eth/useTargetNetwork";

/**
 * Site footer
 */
export const Footer = () => {
  const { targetNetwork } = useTargetNetwork();
  const isLocalNetwork = targetNetwork.id === hardhat.id;

  return (
    <div className="min-h-0 py-5 px-1 mb-11 lg:mb-0">
      <div>
        <div className="fixed flex justify-between items-center w-full z-10 p-4 bottom-0 left-0 pointer-events-none">
          <div className="flex flex-col md:flex-row gap-2 pointer-events-auto">{/* Removed buttons on the left */}</div>
          <SwitchTheme className={`pointer-events-auto ${isLocalNetwork ? "self-end md:self-auto" : ""}`} />
        </div>
      </div>
      <div className="w-full">
        <ul className="menu menu-horizontal w-full">
          <div className="flex justify-center items-center gap-2 text-sm w-full">
            <div className="text-center">
              <p className="m-0 text-center">
                Built with Scaffold-ETH <strong>@ETHOnline 2024</strong> by &nbsp;
                <a href="https://x.com/mart1n_xyz" target="_blank" rel="noreferrer" className="link">
                  mart1n
                </a>
                &nbsp;&bull;&nbsp;
                <a href="https://github.com/mart1n-xyz/daikon" target="_blank" rel="noreferrer" className="link">
                  GitHub
                </a>
              </p>
            </div>
          </div>
        </ul>
      </div>
    </div>
  );
};

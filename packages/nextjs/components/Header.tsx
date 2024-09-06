"use client";

import React, { useCallback, useRef, useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { Bars3Icon, BugAntIcon } from "@heroicons/react/24/outline";
import { FaucetButton, RainbowKitCustomConnectButton } from "~~/components/scaffold-eth";
import { useOutsideClick } from "~~/hooks/scaffold-eth";

type HeaderMenuLink = {
  label: string;
  href: string;
  icon?: React.ReactNode;
  className?: string; // Add this line
};

export const menuLinks: HeaderMenuLink[] = [
  {
    label: "Home",
    href: "/",
    className: "home-button", // Add this line
  },
  {
    label: "About",
    href: "/about",
  },
  {
    label: "Launch",
    href: "/launch",
  },
  {
    label: "Seed",
    href: "/seed",
  },
  {
    label: "Grow",
    href: "/grow",
  },
  {
    label: "Cook",
    href: "/cook",
  },
  {
    label: "Debug Contracts",
    href: "/debug",
    icon: <BugAntIcon className="h-4 w-4" />,
  },
];

export const HeaderMenuLinks = () => {
  const pathname = usePathname();

  return (
    <ul className="flex flex-col lg:flex-row justify-center gap-2 lg:gap-4">
      {menuLinks.map(({ label, href, icon, className }) => {
        // Removed 'index' from here
        const isActive = pathname === href;
        return (
          <React.Fragment key={href}>
            <li className="w-full lg:w-auto">
              <Link
                href={href}
                className={`${
                  isActive ? "bg-secondary shadow-md text-lg font-bold" : "text-lg font-semibold"
                } ${className} hover:bg-secondary hover:shadow-md focus:!bg-secondary active:!text-neutral py-2 px-4 rounded-full gap-2 flex items-center`}
              >
                {icon}
                <span>{label}</span>
              </Link>
            </li>
          </React.Fragment>
        );
      })}
    </ul>
  );
};

export const Header = () => {
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const burgerMenuRef = useRef<HTMLDivElement>(null);
  useOutsideClick(
    burgerMenuRef,
    useCallback(() => setIsDrawerOpen(false), []),
  );

  return (
    <div className="sticky lg:static top-0 navbar bg-base-100 min-h-0 flex-shrink-0 justify-between z-20 shadow-md shadow-secondary px-0 sm:px-2">
      <div className="navbar-start w-auto lg:w-1/3">
        <div className="lg:hidden dropdown" ref={burgerMenuRef}>
          <label
            tabIndex={0}
            className={`ml-1 btn btn-ghost ${isDrawerOpen ? "hover:bg-secondary" : "hover:bg-transparent"}`}
            onClick={() => {
              setIsDrawerOpen(prevIsOpenState => !prevIsOpenState);
            }}
          >
            <Bars3Icon className="h-1/2" />
          </label>
          {isDrawerOpen && (
            <ul
              tabIndex={0}
              className="menu menu-compact dropdown-content mt-3 p-2 shadow bg-base-100 rounded-box w-screen max-w-xs"
              onClick={() => {
                setIsDrawerOpen(false);
              }}
            >
              <HeaderMenuLinks />
            </ul>
          )}
        </div>
      </div>
      <div className="navbar-center hidden lg:flex">
        <ul className="menu menu-horizontal px-1 gap-2">
          <HeaderMenuLinks />
        </ul>
      </div>
      <div className="navbar-end flex-grow mr-4 lg:w-1/3 justify-end">
        <RainbowKitCustomConnectButton />
        <FaucetButton />
      </div>
    </div>
  );
};

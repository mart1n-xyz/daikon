"use client";

//import { useAccount } from "wagmi";
// Removed unused imports
// import { BugAntIcon, MagnifyingGlassIcon } from "@heroicons/react/24/outline";
import Image from "next/image";
import Link from "next/link";
import type { NextPage } from "next";

const Home: NextPage = () => {
  // Removed unused variable
  // const { address: connectedAddress } = useAccount();

  return (
    <>
      <div className="flex items-center flex-col flex-grow pt-10">
        <div className="px-5">
          <h1 className="text-center">
            <span className="block text-5xl font-bold mb-2">Welcome to Daikon</span>
            <span className="block text-2xl mb-4">
              A rad<em>-ish</em> DAO launchpad
            </span>
          </h1>

          <div className="flex flex-col items-center md:max-w-2xl mx-auto">
            <Image
              src="/daikon.jpg"
              alt="Daikon"
              className="w-1/3 md:w-1/3 mb-4"
              width={300} // Add appropriate width
              height={300} // Add appropriate height
            />
            <p className="text-center text-lg">
              Daikon is a DAO launchpad that helps users explore, seed, and grow their DAO ideas. Successful DAOs
              graduate by deploying an ERC20 token and OpenZeppelin&apos;s Governor contract, transforming into fully
              operational DAOs.
            </p>
          </div>
        </div>

        <div className="flex-grow bg-base-300 w-full mt-16 px-8 py-12">
          <div className="flex justify-center items-center gap-6 flex-wrap">
            {/* Commented out original blocks
            <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl">
              <BugAntIcon className="h-8 w-8 fill-secondary" />
              <p>
                Tinker with your smart contract using the{" "}
                <Link href="/debug" passHref className="link">
                  Debug Contracts
                </Link>{" "}
                tab.
              </p>
            </div>
            <div className="flex flex-col bg-base-100 px-10 py-10 text-center items-center max-w-xs rounded-3xl">
              <MagnifyingGlassIcon className="h-8 w-8 fill-secondary" />
              <p>
                Explore your local transactions with the{" "}
                <Link href="/blockexplorer" passHref className="link">
                  Block Explorer
                </Link>{" "}
                tab.
              </p>
            </div>
            */}

            {/* New blocks */}
            <Link
              href="/explore"
              className="flex flex-col bg-base-100 px-6 py-8 text-center items-center w-[250px] h-[200px] rounded-3xl hover:bg-base-200 transition-colors"
            >
              <h3 className="text-lg font-semibold mb-2">Ideate</h3>
              <p className="text-sm">
                Launch your DAO concept, share your vision, and attract initial supporters to your cause.
              </p>
            </Link>
            <Link
              href="/seed"
              className="flex flex-col bg-base-100 px-6 py-8 text-center items-center w-[250px] h-[200px] rounded-3xl hover:bg-base-200 transition-colors"
            >
              <h3 className="text-lg font-semibold mb-2">Seed</h3>
              <p className="text-sm">
                Invest in promising DAO ideas, fund innovative causes, and become an early stakeholder in potential
                game-changers.
              </p>
            </Link>
            <Link
              href="/grow"
              className="flex flex-col bg-base-100 px-6 py-8 text-center items-center w-[250px] h-[200px] rounded-3xl hover:bg-base-200 transition-colors"
            >
              <h3 className="text-lg font-semibold mb-2">Grow</h3>
              <p className="text-sm">
                Join evolving communities, contribute as a builder or volunteer, and help shape the DAO&apos;s direction
                and development.
              </p>
            </Link>
            <Link
              href="/graduate"
              className="flex flex-col bg-base-100 px-6 py-8 text-center items-center w-[250px] h-[200px] rounded-3xl hover:bg-base-200 transition-colors"
            >
              <h3 className="text-lg font-semibold mb-2">Graduate & Cook</h3>
              <p className="text-sm">
                Turn your DAO into a fully decentralized organization with governance contracts and a token, marking the
                start of its journey.
              </p>
            </Link>
          </div>
        </div>
      </div>
    </>
  );
};

export default Home;

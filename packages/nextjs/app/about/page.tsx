import type { NextPage } from "next";
import { FaCarrot, FaLeaf, FaSeedling } from "react-icons/fa";
import { getMetadata } from "~~/utils/scaffold-eth/getMetadata";

export const metadata = getMetadata({
  title: "About Daikon",
  description: "Learn more about Daikon, a rad-ish DAO launchpad",
});

const About: NextPage = () => {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-5xl font-bold text-center mb-8">
        About <span className="text-primary">Daikon</span>
      </h1>
      <p className="text-2xl text-center mb-12">
        A rad<em>-ish</em> DAO launchpad
      </p>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
        <div className="prose max-w-none">
          <h2 className="text-3xl font-semibold mb-4">What is Daikon?</h2>
          <p>
            Daikon is an innovative DAO launchpad that empowers users to explore, seed, and grow their decentralized
            autonomous organization (DAO) ideas. Our platform is designed to nurture DAOs from conception to
            full-fledged operation, providing a seamless journey from ideation to decentralized governance.
          </p>
          <p>
            With Daikon, visionaries and memetics can connect with skilled builders and capital providers, fostering an
            ecosystem where innovative ideas can flourish and transform into impactful, community-driven organizations.
          </p>
        </div>

        <div className="card bg-base-200 shadow-xl">
          <div className="card-body">
            <h2 className="card-title text-2xl mb-4">Key Features</h2>
            <ul className="list-none space-y-2">
              <li className="flex items-center">
                <span className="mr-2 text-primary">
                  <FaSeedling />
                </span>
                <span>
                  <strong>Seed:</strong> Launch your DAO concept and attract initial supporters, raise initial funds and
                  onboard first community members
                </span>
              </li>
              <li className="flex items-center">
                <span className="mr-2 text-primary">
                  <FaLeaf />
                </span>
                <span>
                  <strong>Grow:</strong> Expand your community and builder base, raise funds and onboard new community
                  members
                </span>
              </li>
              <li className="flex items-center">
                <span className="mr-2 text-primary">
                  <FaCarrot />
                </span>
                <span>
                  <strong>Cook:</strong> Graduate to a fully operational DAO with governance contracts, tokens, treasury
                  and an elected steward
                </span>
              </li>
            </ul>
          </div>
        </div>
      </div>

      <div className="mt-12">
        <h2 className="text-3xl font-semibold mb-6">Daikon Launch Phases</h2>

        <div className="collapse collapse-plus bg-base-200 mb-4">
          <input type="radio" name="my-accordion-3" defaultChecked />
          <div className="collapse-title text-xl font-medium">Phase 1: Seed</div>
          <div className="collapse-content">
            <p>In this initial phase:</p>
            <ul className="list-disc list-inside space-y-2">
              <li>Users deploy a Daikon DAO by specifying name, token symbol, image, and description.</li>
              <li>A 3-day funding period commences, with a soft cap of 80 ETH.</li>
              <li>Contributors receive Daikon Seeds proportional to their investment.</li>
              <li>Daikon Seeds are soulbound and non-transferable.</li>
            </ul>
          </div>
        </div>

        <div className="collapse collapse-plus bg-base-200 mb-4">
          <input type="radio" name="my-accordion-3" />
          <div className="collapse-title text-xl font-medium">Phase 2: Grow</div>
          <div className="collapse-content">
            <p>During the growth phase:</p>
            <ul className="list-disc list-inside space-y-2">
              <li>The DAO refines its mission and vision, builds infrastructure, and attracts developers.</li>
              <li>Periodic Seed sales occur to raise funds and onboard new community members.</li>
              <li>Community members can redeem their Seeds for ETH at any time.</li>
              <li>Reaching 80 ETH in total contributions triggers graduation to the Cook phase.</li>
            </ul>
          </div>
        </div>

        <div className="collapse collapse-plus bg-base-200">
          <input type="radio" name="my-accordion-3" />
          <div className="collapse-title text-xl font-medium">Phase 3: Cook</div>
          <div className="collapse-content">
            <p>In the final phase:</p>
            <ul className="list-disc list-inside space-y-2">
              <li>The DAO transitions to full independence upon reaching the 80 ETH threshold.</li>
              <li>ERC20 token and Governor contract are deployed.</li>
              <li>A vesting contract is set up for the DAO steward, chosen by community vote.</li>
              <li>The DAO treasury is established with the raised funds.</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
};

export default About;

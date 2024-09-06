"use client";

import { useEffect, useState } from "react";
import { useAccount } from "wagmi";
import { useScaffoldWriteContract } from "~~/hooks/scaffold-eth";
import { useScaffoldReadContract } from "~~/hooks/scaffold-eth";

// Simplified DaikonDetailsList component
const DaikonDetailsList = ({ daoIds }: { daoIds: Array<bigint> }) => {
  return (
    <div className="bg-base-100 shadow-xl p-8 rounded-lg">
      <h2 className="text-2xl font-bold mb-6">Your Deployed DAOs</h2>
      {daoIds.length > 0 ? (
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
          {daoIds.map(id => (
            <div key={id.toString()} className="bg-base-200 p-4 rounded-lg text-center">
              <span className="text-lg font-medium">DAO ID</span>
              <p className="text-xl font-bold text-primary">{id.toString()}</p>
            </div>
          ))}
        </div>
      ) : (
        <p className="text-center text-gray-500">You haven&apos;t deployed any DAOs yet.</p>
      )}
    </div>
  );
};

const Launch = () => {
  const [name, setName] = useState("");
  const [symbol, setSymbol] = useState("");
  const [contributionPeriod, setContributionPeriod] = useState(3);
  const [telegram, setTelegram] = useState("");
  const [xProfile, setXProfile] = useState("");
  const [discord, setDiscord] = useState("");
  const [manifesto, setManifesto] = useState("");

  const [daoIds, setDaoIds] = useState<Array<bigint>>([]);

  const { writeContractAsync: deployDAOAsync } = useScaffoldWriteContract("DaikonLaunchpad");

  const { address } = useAccount();

  const { data: deployedDAOIds, refetch: refetchDAOIds } = useScaffoldReadContract({
    contractName: "DaikonLaunchpad",
    functionName: "getDaikonsByDeployer",
    args: [address],
  });

  useEffect(() => {
    if (deployedDAOIds) {
      setDaoIds([...deployedDAOIds]); // Convert readonly array to mutable array
    }
  }, [deployedDAOIds]);

  const validateUrl = (url: string) => {
    const urlPattern = /^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/;
    return url === "" || urlPattern.test(url);
  };

  const constructAdditionalData = () => {
    const additionalData: Record<string, string> = {};
    if (xProfile) additionalData.xProfile = xProfile;
    if (telegram) additionalData.telegram = telegram;
    if (discord) additionalData.discord = discord;
    if (manifesto) additionalData.manifesto = manifesto;
    return Object.keys(additionalData).length > 0 ? JSON.stringify(additionalData) : "";
  };

  const validateInputs = () => {
    if (!name.trim()) {
      throw new Error("DAO name is required");
    }
    if (!symbol.trim()) {
      throw new Error("Token symbol is required");
    }
    if (symbol.length > 4) {
      throw new Error("Token symbol must be 4 characters or less");
    }
    if (!contributionPeriod) {
      throw new Error("Contribution period is required");
    }
    if (!validateUrl(telegram) || !validateUrl(xProfile) || !validateUrl(discord)) {
      throw new Error("Please enter valid URLs for Telegram, X Profile, and Discord");
    }
  };

  const handleLaunch = async () => {
    try {
      validateInputs();
      const additionalData = constructAdditionalData();

      await deployDAOAsync({
        functionName: "createDaikon",
        args: [name, symbol, BigInt(contributionPeriod), additionalData],
      });

      console.log("DAO launched successfully");
      await refetchDAOIds(); // Refresh the list after successful launch
    } catch (error) {
      console.error("Error launching DAO:", error);
      alert(error instanceof Error ? error.message : "An error occurred while launching the DAO");
    }
  };

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-5xl font-bold text-center mb-12">
        Launch Your <span className="text-primary">Daikon DAO</span>
      </h1>
      <div className="flex flex-col md:flex-row gap-8">
        <div className="w-full md:w-1/3 order-2 md:order-1">
          <div className="bg-base-100 shadow-xl p-8 rounded-lg mb-8">
            {/* Form inputs */}
            <div className="mb-4">
              <label className="block text-lg font-medium mb-2">Daikon DAO Name</label>
              <input
                type="text"
                className="input input-bordered w-full"
                value={name}
                onChange={e => setName(e.target.value)}
              />
            </div>
            <div className="mb-4">
              <label className="block text-lg font-medium mb-2">Token Symbol</label>
              <input
                type="text"
                className="input input-bordered w-full"
                value={symbol}
                onChange={e => setSymbol(e.target.value)}
              />
            </div>
            <div className="mb-4">
              <label className="block text-lg font-medium mb-2">
                Initial Contribution Period <span className="text-sm text-gray-500">(days)</span>
              </label>
              <select
                className="select select-bordered w-full"
                value={contributionPeriod}
                onChange={e => setContributionPeriod(Number(e.target.value))}
              >
                <option value={1}>1</option>
                <option value={2}>2</option>
                <option value={3}>3</option>
              </select>
            </div>
            <div className="mb-4">
              <label className="block text-lg font-medium mb-2">
                X Profile <span className="text-sm text-gray-500">(optional)</span>
              </label>
              <input
                type="text"
                className="input input-bordered w-full"
                value={xProfile}
                onChange={e => setXProfile(e.target.value)}
              />
            </div>
            <div className="mb-4">
              <label className="block text-lg font-medium mb-2">
                Telegram <span className="text-sm text-gray-500">(optional)</span>
              </label>
              <input
                type="text"
                className="input input-bordered w-full"
                value={telegram}
                onChange={e => setTelegram(e.target.value)}
              />
            </div>
            <div className="mb-4">
              <label className="block text-lg font-medium mb-2">
                Discord <span className="text-sm text-gray-500">(optional)</span>
              </label>
              <input
                type="text"
                className="input input-bordered w-full"
                value={discord}
                onChange={e => setDiscord(e.target.value)}
              />
            </div>
            <div className="mb-4">
              <label className="block text-lg font-medium mb-2">
                Manifesto or Description <span className="text-sm text-gray-500">(optional)</span>
              </label>
              <textarea
                className="textarea textarea-bordered w-full"
                value={manifesto}
                onChange={e => setManifesto(e.target.value)}
              />
            </div>
            <button className="btn btn-primary w-full text-lg py-3 h-auto" onClick={handleLaunch}>
              Launch Daikon DAO
            </button>
          </div>
        </div>

        <div className="w-full md:w-2/3 order-1 md:order-2">
          <div className="bg-base-100 shadow-xl p-8 rounded-lg mb-8">
            <h2 className="text-2xl font-semibold mb-6">Initializing Your Daikon DAO</h2>
            <div className="space-y-4">
              <p>
                By launching a Daikon DAO, you&apos;re taking the first step in bringing your decentralized vision to
                life. Here&apos;s what happens when you initialize your DAO:
              </p>
              <ul className="list-disc list-inside space-y-2">
                <li>Your DAO is created with the specified name, symbol, and additional information.</li>
                <li>A 3-day seed funding period begins immediately after deployment.</li>
                <li>Initial seeders can contribute ETH to support your DAO idea.</li>
                <li>Contributors receive Daikon Seeds proportional to their investment.</li>
                <li>The seed period is capped at 80 ETH to ensure a fair launch.</li>
              </ul>
              <p>
                This seed period is crucial for attracting early supporters and gathering initial resources for your
                DAO. It&apos;s the perfect time to start sharing your vision and building your community!
              </p>
              <div className="mt-4 p-4 bg-base-200 rounded-lg">
                <h3 className="text-lg font-semibold mb-2">Community Building Tip</h3>
                <p>
                  Remember, the success of your DAO greatly depends on effectively communicating your idea across
                  various channels. Utilize social media, forums, and community platforms to share your vision, engage
                  with potential supporters, and foster a vibrant community around your DAO. The connections you build
                  during this early stage can become the foundation for your DAO&apos;s long-term success and growth.
                </p>
              </div>
            </div>
          </div>

          <DaikonDetailsList daoIds={daoIds} />
        </div>
      </div>
    </div>
  );
};

export default Launch;

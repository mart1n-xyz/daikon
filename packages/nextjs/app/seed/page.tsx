"use client";

import { useEffect, useState } from "react";
import { useScaffoldReadContract } from "~~/hooks/scaffold-eth";

const Seed = () => {
  const [daikons, setDaikons] = useState<any[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [currentId, setCurrentId] = useState<number | null>(null);

  const {
    data: count,
    isLoading: isCountLoading,
    error: countError,
  } = useScaffoldReadContract({
    contractName: "DaikonLaunchpad",
    functionName: "getDaikonCount",
  });

  const daikonData = useScaffoldReadContract({
    contractName: "DaikonLaunchpad",
    functionName: "getDaikon",
    args: [currentId !== null ? BigInt(currentId) : undefined],
  });

  const fetchDaikonData = async (id: number) => {
    setCurrentId(id);
  };

  useEffect(() => {
    const fetchDaikons = async () => {
      if (countError) {
        setError(`Error fetching Daikon count: ${countError.message || "Unknown error"}`);
        setIsLoading(false);
      } else if (!isCountLoading && count !== undefined) {
        const daikonPromises = [];
        for (let i = 0; i < Number(count); i++) {
          daikonPromises.push(fetchDaikonData(i));
        }
        try {
          const daikonResults = await Promise.all(daikonPromises);
          setDaikons(daikonResults);
        } catch (err) {
          const error = err as Error; // Type assertion
          setError(`Error fetching Daikon data: ${error.message || "Unknown error"}`);
        } finally {
          setIsLoading(false);
        }
      }
    };

    fetchDaikons();
  }, [count, isCountLoading, countError]);

  useEffect(() => {
    if (currentId !== null) {
      const { data, error } = daikonData;
      if (error) {
        setError(`Error fetching Daikon data for ID ${currentId}: ${error.message || "Unknown error"}`);
      } else if (data) {
        setDaikons(prevDaikons => [...prevDaikons, data]);
      }
    }
  }, [currentId, daikonData]);

  const bigIntReplacer = (key: string, value: any) => {
    return typeof value === "bigint" ? value.toString() : value;
  };

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error}</div>;

  return (
    <div className="container mx-auto px-4 py-8 text-center">
      <h1 className="text-5xl font-bold mb-12">Daikon Data</h1>
      <pre className="text-left">{JSON.stringify(daikons, bigIntReplacer, 2)}</pre>
    </div>
  );
};

export default Seed;

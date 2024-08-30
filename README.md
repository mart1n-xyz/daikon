# Daikon - a rad<em>-ish</em> DAO launchpad

> [!NOTE]
> :construction_worker: ETHOnline 2024 project built using Scaffold-ETH. 

<br>

## About

Daikon is a DAO launchpad that allows users to explore ideas for DAOs, seed them with capital, grow its community and builder base. When the time is right, successful DAOs graduate from Daikon by deploying an ERC20 token with Uniswap liquidity and OpenZeppelin's Governor contract, transforming the initial concept into a fully-fledged, operational DAO. 
This seamless journey from ideation to decentralized governance empowers visionaries and memetics to connect with skilled builders and capital providers, fostering an ecosystem where innovative ideas can flourish and transform into impactful, community-driven organizations.

## Daikon Launch Phases

There are three phases for a Daikon DAO, below we describe each phase in detail along with the requirements for advancement to the next phase.

### Phase 1: Seed
#### Initial Deployment
In the first phase, a user deploys a Daikon DAO by specifying a name, token symbol, image, and description. Optionally, the user can also link a manifesto, whitepaper, roadmap, and other relevant information, along with DAO's social links. If the DAO successfully graduates from Daikon, the deployer will receive 1 ETH as a reward.
#### Funding Period
Following the deployment of the Daikon DAO, a period in which the DAO collects seed capital from users commences. This period is limited to 4 days (or shorter if specified by the deployer) and is capped at a maximum of 80 ETH (ca. $200k). Should this limit be reached, the Daikon DAO graduates and proceeds to the Cook phase. If the limit is not reached, the DAO proceeds to the Grow phase.

#### Seeding Capital
During the funding period, users can contribute ETH to the DAO. There are in total 10,000,000 Daikon Seeds allocated for this phase. Seed allocation is proportional to each contributor's ETH investment relative to the total funds raised, with distribution occurring at the conclusion of the funding period. For example, if a user contributes 0.1 ETH to a DAO that raises a total of 10 ETH, they will receive 100,000 Daikon Seeds. This mechanism ensures a level playing field for all early community members and contributors, regardless of the amount they invest.

Daikon Seeds are not represented as ERC20 tokens as they live only within the Daikon smart contract and are soulbound and not transferable. However, they can be redeemed in the Grow phase as we describe below.

### Phase 2: Grow
This phase is dedicated to the growth of the community and the builder base. With its founding community, the Daikon DAO should use this time to refine its mission and vision, build basic infrastructure and attract developers to join the project. Reaching 80 ETH in total contributions will trigger graduation from the launchpad and transition to the Cook phase.

#### Growing the Community through Periodic Seed Sales
While the Daikon DAO is below the graduation limit, it will periodically sell additional Daikon Seeds to raise funds and onboard new community members. These sales are open to anyone and the proceeds are added to the DAO's contributions. New Seeds are minted for each sale and added to the circulating supply; the allocation for each sale is 10-25% percent of the total supply (set by the deployer). Each sale period is 3 days long and after the sale concludes, another one begins. Sales cease once the DAO has reached the graduation limit.

The format of the sale is similar to the initial funding round. Users deposit ETH during the sale period and upon the sale concluding, they receive a proportional amount of allocated Daikon Seeds. 


#### Option to Redeem Seeds
Given the open-ended nature of the Grow phase, we allow community members to redeem their Seeds at any point during this phase and leave the project. This option allows them to turn their Daikon Seeds back into ETH, providing them with the flexibility to allocate resources as needed. 

The redemption amount is calculated based on the user's proportional share of Seeds relative to the total circulating supply at the time of redemption. This proportion determines the percentage of the Daikon DAO's current contributions that the user will receive. Naturally, redemptions decrease the current amount of ETH contributed to the Daikon DAO. For example, if a user holds 10% of the circulating Seeds and chooses to redeem them when the DAO has 50 ETH in contributions, they would receive 5 ETH (10% of 50 ETH) and the DAO will be left with 45 ETH.

### Phase 3: Cook
The Cook phase marks the culmination of the Daikon DAO's journey on the launchpad. Upon reaching the 80 ETH graduation threshold, the DAO transitions to full independence and the dev(s) can start cooking. 

#### Setting up the DAO for Success
To ensure the DAO's success and establish a solid foundation for further growth, the launchpad initiates several crucial steps during this period. It deploys the ERC20 token and the Governor contract, facilitating a smooth transition from Seed tokens to the new transferable ERC20 token. Additionally, a portion of the new token supply is allocated to a vesting contract, specifically designed for the founding team or developers. This strategic approach aligns long-term incentives for key contributors and the DAO community.

##### Stewardship of the DAO
Every DAO needs long-term core contributors to build the vision of the project. Therefore, a vesting contract with 4 year linear vesting schedule is deployed. The address that will earn right to this allocation is decided by the community. This contract is pausable by the DAO governance should there be issues with the steward.

Upon claiming their ERC20 allocation, Seed holders will be asked to vote for an address to become the steward. The winner of this vote, after 3 days, will be assigned the vesting contract and expected to start building the project. Candidates for this role are expected to register their candidacy prior to the vote for a small fee (0.01 ETH) as a spam prevention measure. This can be done from the DAO deployment on Daikon up to the graduation of the DAO. It is expected that the steward will be chosen based on prior contributions to the project and alignment with the DAO's vision. It can be a single builder or a number of key contributors represented by a multisig or further smart contract logic. Should there be no candidate, the vesting contract will be assigned to the 0x address and the associated token allocation, therefore, burned.

##### DAO-Owned Liquidity and Treasury
Extra tokens will be minted and paired with the ETH contributed via Daikon to supply liquidity via Uniswap. This LP positions will be transfered to DAO's new treasury. 

The treasury will be further assigned additional newly-minted ERC20 tokens, empowering the DAO with resources for project development and product incentivization. The allocation and utilization of these tokens will be subject to community governance.

Upon graduation, Seed holders receive their allocation of the ERC20 token, forming the initial circulating supply. This supply, however, is dynamic. The vesting contract for the DAO steward gradually releases tokens over time, while the Uniswap liquidity pool enables new participants to acquire tokens. These mechanisms contribute to a gradual and organic growth of the token's circulating supply. This approach ensures a balanced distribution and aligns with the DAO's long-term development and community expansion goals.

Daikon will not provide any interface for the governance of the DAO after graduation. The DAO will be able to utilize the variety of DAO tools available, such as Tally, Snapshot, etc.



## Requirements

- [Node (>= v18.17)](https://nodejs.org/en/download/)
- Yarn ([v1](https://classic.yarnpkg.com/en/docs/install/) or [v2+](https://yarnpkg.com/getting-started/install))
- [Git](https://git-scm.com/downloads)

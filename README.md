# 📚 OERDAO: Community-Funded Open Educational Resources DAO

Welcome to OERDAO, a decentralized autonomous organization (DAO) built on the Stacks blockchain using Clarity smart contracts! This project empowers communities to fund, vote on, and create open educational resources (OER) like courses, textbooks, and tutorials. It solves real-world problems such as underfunding of quality educational content, lack of democratic input in resource development, and opaque tracking of resource usage, ensuring transparency and accountability in global education.

## ✨ Features

💰 Community funding pool for OER projects via token contributions  
🗳️ DAO voting on content proposals using governance tokens  
📝 Register and publish OER content with immutable metadata  
🔍 Transparent usage tracking (views, downloads, citations) on-chain  
🏆 Reward creators based on verified usage metrics  
🌐 Open access to all approved OER, integrable with platforms like Moodle or Khan Academy  
🔒 Anti-plagiarism checks via content hashing  
📊 Analytics for funders to see impact (e.g., global reach, engagement stats)  
🤝 Multi-signature treasury for secure fund releases  

## 🛠 How It Works

**For Community Members/Funders**  
- Join the DAO by staking governance tokens (OER tokens).  
- Propose new OER content ideas or vote on existing proposals.  
- Contribute to the funding pool to support approved projects.  
- Track usage stats to see how funded resources are performing worldwide.  

**For Content Creators**  
- Submit proposals with content outlines and funding requests.  
- Upon approval, create and register OER with a unique hash.  
- Earn rewards automatically based on on-chain usage data.  

**For Users/Learners**  
- Access free OER resources via the platform.  
- Interactions (e.g., views) are tracked transparently to inform future funding.  
- Verify content authenticity and ownership instantly.  

OERDAO uses Stacks for efficient, Bitcoin-secured transactions, making community-driven education sustainable and transparent!

## 📚 Smart Contracts Overview

This project involves 8 Clarity smart contracts to manage the DAO's operations. Here's a breakdown:

1. **MembershipDAO.clar**: Handles DAO membership via NFT minting for members. Manages joining, leaving, and token staking for voting rights.  
2. **GovernanceVoting.clar**: Facilitates proposal creation, voting, and execution. Uses quadratic voting to prevent whale dominance.  
3. **TreasuryFund.clar**: Manages the community funding pool. Handles deposits, withdrawals, and multi-sig releases for approved projects.  
4. **ProposalSystem.clar**: Stores and validates content proposals, including details like budget, timeline, and creator info. Integrates with voting.  
5. **ContentRegistry.clar**: Registers OER content with hashes, metadata (title, description, license), and ownership proofs. Prevents duplicates.  
6. **UsageTracker.clar**: Logs and aggregates usage events (e.g., views, downloads) on-chain. Uses oracles for off-chain data verification.  
7. **RewardDistributor.clar**: Calculates and distributes rewards to creators based on usage metrics. Supports token vesting.  
8. **AnalyticsEngine.clar**: Provides query functions for usage stats, funding impact, and DAO performance dashboards without off-chain storage.  

## 🚀 Getting Started

1. Install the Clarinet tool for Clarity development.  
2. Clone this repo and deploy the contracts to Stacks testnet.  
3. Integrate with a frontend (e.g., React + Hiro Wallet) for user interactions.  
4. Join the DAO—call `stake-tokens` from MembershipDAO to participate!  

Empower education through decentralization with OERDAO today! 🌟
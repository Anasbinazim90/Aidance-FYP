import Web3 from "web3";
import DAOhandlerApi from "../../../../abi/DAOHandler.json";

const providerURL = process.env.RPC_URL;
const contractAddress = process.env.DAO_Token_Contract;

// Initialize Web3
const web3 = new Web3(new Web3.providers.HttpProvider(providerURL));
const DAOHandler = new web3.eth.Contract(DAOhandlerApi.abi, contractAddress);

export default async function handler(req, res) {
  const { campaignId } = req.query;

  if (req.method !== "GET") {
    return res
      .setHeader("Allow", ["GET"])
      .status(405)
      .end(`Method ${req.method} Not Allowed`);
  }

  if (!campaignId ) {
    return res
      .status(400)
      .json({ error: "Campaign Id is required." });
  }

  try {
    const ifAccepted = await DAOHandler.methods
      .acceptedCampaigns(campaignId)
      .call();
    return res.status(200).json({ CampaignAcceptedOrNot: ifAccepted });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ error: error.message });
  }
}

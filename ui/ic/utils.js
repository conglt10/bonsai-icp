import { Actor, HttpAgent } from '@dfinity/agent';
import { Principal } from '@dfinity/principal';
// import { bonsaiIDL } from '/ic/candid/bonsaicp.did.js';

export const canisterId = process.env.REACT_APP_BONSAI_CANISTER_ID;

export const createActor = (canisterId, options) => {
  const agent = new HttpAgent({ ...options?.agentOptions });

  // Fetch root key for certificate validation during development
  if (process.env.REACT_APP_ENV !== 'production') agent.fetchRootKey();

  // Creates an actor with using the candid interface and the HttpAgent
  return Actor.createActor(idlFactory, {
    agent,
    canisterId,
    ...options?.actorOptions,
  });
};

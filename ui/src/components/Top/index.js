import React, { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import oxyImg from 'images/oxygen_bubble_big.png';
import plusImg from 'images/plus.png';
import { useDispatch } from 'react-redux';
import * as actions from 'store/actions';
import AirDrop from 'components/AirDrop';
import { Modal } from 'antd';
import { BuyOxy } from 'components/OxyStore';
import PlugConnect from '@psychedelic/plug-connect';
import { whiteListCanister } from 'constant';

import './top.css';

function Top() {
  const dispatch = useDispatch();
  const address = useSelector((state) => state.walletAddress);
  const balanceOxy = useSelector((state) => state.balanceOxy);
  const [openModalBuyOxy, setOpenModalBuyOxy] = useState(false);

  const setPrincipalId = async () => {
    const principalId = await window.ic.plug.agent.getPrincipal();
    const shortPrincipalId = `${principalId.toString().slice(0, 5)}...${principalId
      .toString()
      .slice(-3)}`;

    dispatch(actions.setAddress(shortPrincipalId));
  };

  const verifyConnectionAndAgent = async () => {
    const host = 'https://mainnet.dfinity.network';

    const connected = await window.ic.plug.isConnected();
    if (!connected) window.ic.plug.requestConnect({ whitelist: whiteListCanister, host });
    if (connected && !window.ic.plug.agent) {
      window.ic.plug.createAgent({ whitelist: whiteListCanister, host });
    }
  };

  useEffect(() => {
    //verifyConnectionAndAgent();
  }, []);

  return (
    <div className='oxy-area p-10px'>
      {/* Airdrop 30 Oxy for first-time use per address */}
      <AirDrop />

      <div className='oxy-num connect-wallet'>
        {address ? <img src={oxyImg} className='oxy-img ' alt='oxy' /> : <></>}

        {address ? (
          `${!balanceOxy ? 0 : balanceOxy} - ${address}`
        ) : (
          <PlugConnect whitelist={whiteListCanister} onConnectCallback={setPrincipalId} />
        )}

        {address ? <img src={oxyImg} className='oxy-img oxi-pointer buy-oxy' alt='oxy2' /> : <></>}
      </div>
      <Modal
        title='Oxygen Store'
        visible={openModalBuyOxy}
        cancelButtonProps={{ style: { display: 'none' } }}
        okButtonProps={{ style: { display: 'none' } }}
        onCancel={() => setOpenModalBuyOxy(!openModalBuyOxy)}
      >
        <BuyOxy onClose={() => setOpenModalBuyOxy(!openModalBuyOxy)} />
      </Modal>
    </div>
  );
}

export default Top;

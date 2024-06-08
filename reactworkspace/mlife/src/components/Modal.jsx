import React from 'react';
import styled from 'styled-components';

const Modal = ({ show, onClose, onConfirm, message }) => {
  if (!show) {
    return null;
  }

  return (
    <ModalOverlay>
      <ModalContainer>
        <ModalMessage>{message}</ModalMessage>
        <ButtonWrapper>
          <ModalButton onClick={onConfirm}>확인</ModalButton>
          <ModalButton onClick={onClose}>취소</ModalButton>
        </ButtonWrapper>
      </ModalContainer>
    </ModalOverlay>
  );
};

export default Modal;

const ModalOverlay = styled.div`
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
`;

const ModalContainer = styled.div`
  background: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
  text-align: center;
`;

const ModalMessage = styled.p`
  margin-bottom: 20px;
  font-size: 16px;
  color: #333;
`;

const ButtonWrapper = styled.div`
  display: flex;
  justify-content: space-around;
`;

const ModalButton = styled.button`
  padding: 10px 20px;
  font-size: 16px;
  color: white;
  background-color: #ffca28;
  border: none;
  border-radius: 4px;
  cursor: pointer;
`;

import styled from 'styled-components';
import { BaseButton } from './Shared.styles';

export const ModalContainer = styled.dialog`
  &[open] {
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    max-width: 312px;
    display: flex;
    padding: 16px;
    flex-direction: column;
    align-items: center;
    gap: 18px;
    border: none;
    border-radius: 4px;
    background: #211f26;
    box-shadow: 0px 1px 2px 0px rgba(0, 0, 0, 0.3),
      0px 2px 6px 2px rgba(0, 0, 0, 0.15);
  }
  &[open]::backdrop {
    background: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(3px);
  }
`;

export const Title = styled.h3`
  display: flex;
  width: 280px;
  flex-direction: column;
  justify-content: center;
  color: var(--m-3-white, #fff);
  text-align: center;
  font-family: Roboto, sans-serif;
  font-size: 14px;
  font-style: normal;
  font-weight: 400;
  line-height: 20px;
  letter-spacing: 0.25px;
`;

export const Divider = styled.hr`
  display: flex;
  padding: 0px 16px;
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  width: 248px;
  height: 1px;
  background: #49454f;
  border: none;
`;

export const ActionButton = styled(BaseButton)`
  background-color: transparent;
  color: var(--m-3-sys-dark-error, #f2b8b5);
  font-weight: 500;
`;

export const CancelButton = styled(BaseButton)`
  background: var(--m-3-sys-dark-error, #f2b8b5);
  color: var(--m-3-sys-dark-error-container, #8c1d18);
  font-weight: 700;
`;

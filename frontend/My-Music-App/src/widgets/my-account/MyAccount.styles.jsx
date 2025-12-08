import styled, { css } from 'styled-components';

export const flexCenter = css`
  display: flex;
  align-items: center;
  justify-content: center;
`;

export const Wrapper = styled.div`
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  font-family: Roboto, sans-serif;
  gap: 16px;
  color: #fff;
`;
export const Header = styled.h2`
  font-size: 22px;
  font-weight: 400;
  line-height: 28px;
  letter-spacing: 0;
  text-align: left;
`;

export const PersonalDataForm = styled.form`
  ${flexCenter};
  flex-direction: column;
  width: max-content;
  gap: 32px;
  margin-bottom: 32px;
`;

export const FormText = styled.p`
  font-size: 16px;
  font-weight: 500;
  line-height: 24px;
  letter-spacing: 0.15px;
  text-align: left;
  align-self: flex-start;
`;

export const AvatarWrap = styled.div`
  ${flexCenter};
  flex-direction: column;
  gap: 16px;
`;

export const AvatarItem = styled.div`
  ${flexCenter};
  flex-direction: column;
  height: 264px;
  aspect-ratio: 1;
  position: relative;
`;
export const AvatarInput = styled.input`
  display: none;
`;
export const UploadIcon = styled.div`
  width: 52px;
  height: 52px;
  border-radius: 50%;
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  bottom: 5%;
  right: 5%;
  cursor: pointer;
  opacity: 0.5;

  &:hover {
    opacity: 1;
    transition: opacity 0.2s ease-in-out;
  }
`;

export const AvatarImage = styled.img`
  height: 100%;
  width: 100%;
  object-fit: cover;
  border-radius: 50%;
`;

export const DataWrap = styled(AvatarWrap)`
  & > fieldset {
    position: relative;
    width: 328px;
    height: 56px;
    border-radius: 4px;
  }

  & > fieldset > legend {
    font-size: 12px;
    font-weight: 400;
    line-height: 16px;
    letter-spacing: 0;
    text-align: left;
    color: #cac4d0;
    padding: 0 4px;
    margin-left: 8px;
  }
`;

export const FormInput = styled.input`
  width: 100%;
  height: 100%;
  padding: 8px 40px 8px 12px;
  color: #e6e0e9;
`;

export const InputClearButton = styled.button`
  position: absolute;
  top: -3px;
  right: 5px;
  width: 40px;
  height: 40px;
  border: none;
  background: transparent;
  cursor: pointer;

  & > .clear-icon {
    width: 24px;
    height: 24px;
    color: #cac4d0;
  }

  & > .clear-icon:hover {
    scale: 1.1;
    transition: scale 0.2s ease-in-out;
  }
`;

export const AvatarDeleteIcon = styled.button`
  width: 52px;
  height: 52px;
  border: none;
  border-radius: 50%;
  background: transparent;
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  top: 5%;
  left: 5%;
  cursor: pointer;
  opacity: 0.5;

  &:disabled {
    background: #e6e0e91f;
    color: #938f99;
    cursor: not-allowed;
  }

  &:hover:not(:disabled) {
    opacity: 1;
    scale: 1.1;
    transition: all 0.2s ease-in-out;
    transform: rotate(180deg);
  }
`;

export const ActionWrap = styled.div`
  ${flexCenter};
  flex-direction: row;
  gap: 24px;
`;

export const BaseButton = styled.button`
  width: 224px;
  height: 40px;
  border-radius: 100px;
  cursor: pointer;
  font-size: 14px;
  font-weight: 500;
  line-height: 20px;
  letter-spacing: 0.1px;
  text-align: center;
`;
export const FormSubmitButton = styled(BaseButton)`
  background: #d0bcff;
  border: none;
  color: #381e72;

  &:disabled {
    background: #e6e0e91f;
    color: #938f99;
    cursor: not-allowed;
  }

  &:hover:not(:disabled) {
    background: #9a82db;
    border: none;
    color: #21005d;
    transition: background 0.2s ease-in-out;
  }
`;

export const FormResetButton = styled(BaseButton)`
  background: transparent;
  border: 1px solid #938f99;
  color: #d0bcff;

  &:hover {
    background: #ec928e;
    border: 1px solid #ec928e;
    color: #b3261e;
    transition: background 0.2s ease-in-out;
  }
`;

export const DeleteAccountFormText = styled(FormText)`
  align-self: center;
`;

export const DeleteAccountButton = styled(BaseButton)`
  background: transparent;
  color: #dc362e;
  font-size: 16px;
  font-weight: 400;
  line-height: 24px;
  letter-spacing: 0.5px;
  text-align: center;
  border: none;

  &:hover {
    background: #dc362e;
    color: #410e0b;
    font-weight: 400;
    transition: all 0.2s ease-in-out;
  }
`;

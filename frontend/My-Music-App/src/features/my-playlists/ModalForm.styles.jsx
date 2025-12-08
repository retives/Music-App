import styled from 'styled-components';
import {
  flexColumnCenter,
  flexVerticalCenter,
} from '../../shared/Shared.styles';

export const EditPlaylistModalContainer = styled.dialog`
  &[open] {
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    padding: 24px;
    ${flexColumnCenter}
    gap: 12px;
    pointer-events: visible;
    border: none;
    border-radius: 16px;
    background: #211f26;
    box-shadow: 0px 1px 2px 0px rgba(0, 0, 0, 0.3),
      0px 2px 6px 2px rgba(0, 0, 0, 0.15);
    font-family: Roboto, sans-serif;
  }
  &[open]::backdrop {
    background: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(3px);
  }
`;

export const Header = styled.div`
  width: 34vw;
  display: flex;
  justify-content: space-between;
  height: 5vh;
  color: rgba(202, 196, 208, 1);
`;

export const Title = styled.p`
  font-size: 22px;
  font-style: normal;
  font-weight: 400;
  line-height: 1.27;
  margin: 0;
`;

export const CloseButton = styled.p`
  cursor: pointer;
`;

export const Details = styled.div`
  width: 34vw;
  display: flex;
  flex-direction: column;
  justify-content: center;
`;

export const Form = styled.form`
  width: 34vw;
  display: grid;
  grid-template: repeat(4, auto) / 1fr;
`;

export const LogoItem = styled.div`
  justify-self: center;
  ${flexVerticalCenter}
  position: relative;
  width: fit-content;
`;

export const LogoWrap = styled.div`
  height: 150px;
  width: 150px;

  background: transparent;
  ${flexVerticalCenter}
  cursor: pointer;
`;

export const DeleteLogoButton = styled.button`
  position: absolute;
  top: calc(1em / 6);
  right: calc(1em / 6);
  background: transparent;
  border: none;
  cursor: pointer;
  font-size: 32px;
  color: #ff0000;
  color: var(--m-3-ref-error-error-40, #b3261e);
  transition: scale 0.2s ease-in-out;

  &:hover {
    color: var(--m-3-ref-error-error-50, #dc362e);
    transform: scale(1.1);
  }

  & > svg {
    filter: drop-shadow(0px 0px 1px var(--m-3-ref-neutral-neutral-100, #fff))
      drop-shadow(0px 0px 3px rgba(255, 255, 255, 0.5));
  }
`;

export const CoverImage = styled.img`
  height: 100%;
  width: 100%;
  border-radius: 18px;
  object-fit: cover;

  &:hover {
    filter: brightness(90%);
  }
`;

export const FileInput = styled.input`
  display: none;
`;

export const ValidationLabel = styled.p`
  color: #cac4d0;
  margin: 0;
  font-size: 14px;
`;

export const FormLabel = styled.label`
  font-size: small;
  position: relative;
  left: 16px;
  top: 9px;
  z-index: 1;
  background-color: rgba(29, 27, 32, 1);
  padding-left: 3px;
  padding-right: 3px;
  color: rgba(202, 196, 208, 1);
`;

export const PlaylistNameWrap = styled.div`
  border: 1px solid #cac4d0;
  border-radius: 5px;
  height: 3em;
`;

export const NameContainer = styled.div`
  height: 5em;
  position: relative;
`;

export const DescriptionContainer = styled.div`
  height: 10em;
`;

export const PlaylistDescriptionWrap = styled.div`
  border: 1px solid #cac4d0;
  border-radius: 5px;
  height: 6em;
`;

export const NameInput = styled.input`
  background-color: transparent;
  font-size: 16px;
  line-height: 24px;
  letter-spacing: 0.5px;
  padding-left: 16px;
  border: none;
  margin-top: 2px;
  width: 95%;
  height: 95%;
  outline: none;
  color: rgba(202, 196, 208, 1);
  &:focus {
    outline: none;
    color: rgba(202, 196, 208, 1);
  }
`;

export const DescriptionInput = styled.textarea`
  width: 100%;
  height: 100%;
  font-size: 16px;
  font-family: Roboto, sans-serif;
  line-height: 24px;
  letter-spacing: 0.5px;
  padding-top: 1em;
  padding-left: 1em;
  background: transparent;
  color: rgba(202, 196, 208, 1);
  border: none;
  resize: none;
  outline: none;
`;

const BaseButton = styled.button`
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  padding: 10px 24px;

  width: 224px;
  border-radius: 100px;
  border: 1px solid var(--m-3-sys-dark-outline, #938f99);

  color: var(--m-3-sys-dark-error, #f2b8b5);
  text-align: center;

  font-family: Roboto, sans-serif;
  font-size: 14px;
  font-style: normal;

  line-height: 20px;
  letter-spacing: 0.1px;
`;

export const SubmitButton = styled(BaseButton)`
  background: var(--m-3-sys-dark-error, #f2b8b5);
  color: var(--m-3-sys-dark-error-container, #8c1d18);
  font-weight: 700;
  margin-left: auto;
  margin-right: auto;
  cursor: pointer;
`;

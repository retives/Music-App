import styled from 'styled-components';
import ImgWrap from '../shared/ImgWrap/ui/ImgWrap';

export const ModalContainer = styled.dialog`
  &[open] {
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    display: flex;
    padding: 24px;
    flex-direction: column;
    align-items: center;
    pointer-events: visible;
    border: none;
    border-radius: 16px;
    background: #211f26;
    box-shadow: 0px 1px 2px 0px rgba(0, 0, 0, 0.3),
      0px 2px 6px 2px rgba(0, 0, 0, 0.15);
  }
  &[open]::backdrop {
    background: rgba(0, 0, 0, 0.01);
  }
`;

export const Header = styled.div`
  width: 34vw;
  display: flex;
  align-items: center;
  justify-content: space-between;
  color: rgba(202, 196, 208, 1);
  margin-bottom: 1em;
`;

export const Title = styled.p`
  font-family: Roboto, sans-serif;
  font-size: 22px;
  font-style: normal;
  font-weight: 400;
  line-height: 1.27;
`;

export const CloseButton = styled.button`
  cursor: pointer;
  padding: 8px;
  background: none;
  border: none;
`;

export const CrossSvg = styled.img`
  display: block;
`;

export const SearchBarWrapper = styled.form`
  background-color: rgba(43, 41, 48, 1);
  color: rgba(202, 196, 208, 1);
  font-size: 16px;
  width: 100%;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1em;
  border-radius: 25px;
`;

export const SearchBarInput = styled.input`
  font-size: 16px;
  padding-left: 15px;
  height: 5vh;
  width: 100%;
`;
export const SearchBarIcon = styled.button`
  border: none;
  background-color: transparent;
  color: rgba(202, 196, 208, 1);
  position: relative;
  right: 1em;
  cursor: pointer;
`;

export const AddSongsMain = styled.div`
  width: 100%;
`;

export const AddSongsTitle = styled.div`
  color: white;
  font-size: 15px;
  margin-bottom: 1em;
`;

export const SongList = styled.div`
  height: 43vh;
  display: flex;
  flex-direction: column;
  overflow: scroll;
  gap: 16px;
`;

export const SongItem = styled.div`
  height: 7.2vh;
  background-color: #141218;
  border-radius: 10px;
  display: flex;
  flex-direction: row;
  align-items: center;
  color: rgba(230, 224, 233, 1);
`;

export const SongImgWrapper = styled.div`
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  border-bottom-left-radius: 10px;
  border-top-left-radius: 10px;
  overflow: hidden;
`;

export const SongImg = styled(ImgWrap)`
  height: 100%;
  aspect-ratio: 1/1;
`;

export const SongArtistInfo = styled.div`
  display: flex;
  flex-direction: column;
  margin-left: 16px;
`;

export const SongTitle = styled.div`
  font-size: 16px;
  font-weight: 500;
  line-height: 1.5;
  letter-spacing: 0.15px;
  margin-bottom: 4px;
`;

export const SongInfo = styled.div`
  display: flex;
  justify-content: left;
  align-items: center;
  font-size: 11px;
  font-weight: 500;
  line-height: 1.45;
  letter-spacing: 0.5px;
`;

export const AddSongIcon = styled.div`
  margin-left: auto;
  margin-right: 1em;
  cursor: pointer;

  & > svg {
    font-size: 24px;
  }
  & > .addsong-item-icon {
    color: white;
  }

  & > .addsong-item-already-added {
    color: var(--m-3-ref-primary-primary-60, #9a82db);
  }
`;

export const WarningMessage = styled.p`
  display: block;
  text-align: center;
  margin-top: 30px;
  color: white;
`;

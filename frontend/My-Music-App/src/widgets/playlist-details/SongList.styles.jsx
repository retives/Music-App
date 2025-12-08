import styled from 'styled-components';
import ImgWrap from '../../features/shared/ImgWrap/ui/ImgWrap';

const songItemHeight = 100;
const songItemGap = 24;
const numOfSongs = 5;
const songListHeight =
  songItemHeight * numOfSongs + songItemGap * (numOfSongs - 1);
const scrollbarWidth = `10px`;
const scrollbarTrackColor = `var(--m-3-ref-secondary-secondary-20, #332D41)`;
const scrollbarColor = `var(--m-3-ref-primary-primary-50, #7F67BE)`;

export const SongsContainer = styled.ul`
  max-height: ${songListHeight}px;
  overflow-y: scroll;
  display: flex;
  flex-direction: column;
  gap: 24px;
  position: relative;

  &::-webkit-scrollbar {
    width: ${scrollbarWidth};
  }
  &::-webkit-scrollbar-track {
    background: ${scrollbarTrackColor};
  }
  &::-webkit-scrollbar-thumb {
    background: ${scrollbarColor};
  }
  &::-webkit-scrollbar-thumb:hover {
    background: ${scrollbarColor};
  }
  & {
    scrollbar-width: thin;
    scrollbar-color: ${scrollbarColor} ${scrollbarTrackColor};
  }
`;

export const SongItem = styled.li`
  display: block;
`;

export const Song = styled.div`
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  box-shadow: 0px 1px 3px 1px rgba(0, 0, 0, 0.15);
  filter: drop-shadow(0px 1px 2px rgba(0, 0, 0, 0.3));
  border-radius: 12px;
  background-color: rgb(23, 23, 23);
  padding-right: 16px;
`;

export const SongCard = styled.div`
  display: flex;
  flex-direction: row;
  justify-content: space-evenly;
  gap: 5px;
  height: ${songItemHeight}px;
`;

export const SongImgWrapper = styled.div`
  display: flex;
  align-items: center;
  border-bottom-left-radius: 10px;
  border-top-left-radius: 10px;
  overflow: hidden;
`;

export const SongCover = styled(ImgWrap)`
  width: 100px;
`;

export const SongArtistInfo = styled.div`
  display: flex;
  flex-direction: column;
  justify-content: center;
  margin-left: 16px;
  gap: 8px;
`;

export const SongTitle = styled.div`
  color: #e6e0e9;
  font-size: 16px;
  font-weight: 500;
  line-height: 1.5;
  letter-spacing: 0.15px;
`;

export const SongInfo = styled.div`
  display: flex;
  justify-content: left;
  align-items: center;
  font-size: 14px;
  font-weight: 500;
  line-height: 1.45;
  letter-spacing: 0.5px;
  color: #aea9b1;
`;

export const VerticalMenu = styled.div`
  position: relative;
  display: flex;
  padding-right: 10px;
  flex-direction: column;
  justify-content: center;
  color: white;
  cursor: pointer;

  @media (max-width: 600px) {
    width: 100%;
    display: flex;
    flex-direction: column;
    justify-content: flex-start;
  }
`;

export const DeleteModal = styled.div`
  display: flex;
  min-width: 210px;
  max-width: 278px;
  width: max-content;
  padding: 8px 0px;
  min-height: 40px;
  align-items: center;
  position: absolute;
  right: 150%;
  top: 20%;
  border-radius: 4px;
  background: var(--m-3-sys-dark-surface-container, #211f26);
  box-shadow: 0px 1px 2px 0px rgba(0, 0, 0, 0.3),
    0px 2px 6px 2px rgba(0, 0, 0, 0.15);

  &:hover {
    color: rgba(242, 184, 181, 1);
    cursor: pointer;
  }
`;

export const DeleteTag = styled.div`
  display: flex;
  height: 40px;
  padding: 8px 12px;
  align-items: center;
  gap: 12px;
  align-self: stretch;
  color: var(--m-3-sys-dark-error, #f2b8b5);
  font-family: Roboto, sans-serif;
  font-size: 16px;
  font-style: normal;
  font-weight: 400;
  line-height: 24px;
  letter-spacing: 0.5px;
`;

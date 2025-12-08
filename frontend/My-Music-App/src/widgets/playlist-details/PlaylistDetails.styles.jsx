import styled, { css } from 'styled-components';

const oneLineEllipsis = css`
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
`;
export const flexCenter = css`
  display: flex;
  align-items: center;
  justify-content: center;
`;

export const ProfileContainer = styled.section`
  width: 360px;
  font-family: 'Roboto', sans-serif;
  font-style: normal;
  color: var(--m-3-white, #fff);
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  grid-template-rows: repeat(2, auto) 360px repeat(4, auto);
  grid-template-areas:
    'header header'
    'hereSince playlistsOwned'
    'cover cover'
    'name name'
    'description description'
    'created updated'
    'dislike like';
  justify-items: center;
  column-gap: 12px;
`;

export const ProfileVerticalMenu = styled.div`
  position: absolute;
  top: 0;
  right: -48px;
  font-size: 24px;
  padding: 12px;
`;

export const ProfileEmail = styled.h3`
  grid-area: header;
  font-size: 22px;
  font-weight: 400;
  line-height: 28px;
  margin-bottom: 8px;
`;

export const ProfileText = styled.span`
  font-size: 14px;
  font-weight: 500;
  line-height: 20px;
  letter-spacing: 0.1px;
  margin-bottom: 36px;
  color: var(--m-3-ref-neutral-variant-neutral-variant-70, #aea9b4);

  &.profile__text--register {
    grid-area: hereSince;
    justify-self: end;
  }

  &.profile__text--playlist-amount {
    grid-area: playlistsOwned;
    justify-self: start;
  }

  &.profile__text--created {
    grid-area: created;
    justify-self: end;
  }

  &.profile__text--updated {
    grid-area: updated;
    justify-self: start;
  }
`;

export const ProfileCover = styled.div`
  grid-area: cover;
  height: 100%;
  aspect-ratio: 1/1;
  border-radius: 18px;
  background-image: url(${(props) => props.$coverUrl}),
    linear-gradient(lightgray, lightgray);
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  box-shadow: 0px 4px 4px 0px rgba(0, 0, 0, 0.3),
    0px 8px 12px 6px rgba(0, 0, 0, 0.15);
  position: relative;

  & > .profile__playlist-type {
    position: absolute;
    right: 24px;
    bottom: 24px;
    height: 32px;
    padding: 6px 12px;
    display: inline-flex;
    justify-content: center;
    align-items: center;
    text-transform: capitalize;
    border-radius: 18px;
    background: var(--m-3-ref-error-error-60, #e46962);
  }

  & > .profile__playlist-type--shared {
    background: #6750a4;
  }
`;

export const ProfilePlaylistName = styled.span`
  grid-area: name;
  place-self: center;
  text-align: center;
  width: 100%;
  font-size: 24px;
  font-weight: 400;
  line-height: 32px;
  ${oneLineEllipsis}
  margin-top: 16px;
  margin-bottom: 8px;
`;

export const ProfileDescription = styled.span`
  grid-area: description;
  text-align: center;
  place-self: center;
  width: 100%;
  color: var(--m-3-ref-neutral-neutral-70, #aea9b1);
  font-size: 16px;
  font-weight: 500;
  line-height: 24px;
  letter-spacing: 0.15px;
  ${oneLineEllipsis}
  margin-bottom: 8px;
`;

export const ProfileRating = styled.span`
  ${flexCenter}
  gap: 4px;
  color: var(--m-3-white, #fff);
  font-size: 12px;
  font-weight: 400;
  line-height: 16px;

  & > svg {
    font-size: 24px;
  }

  &.profile__rating--dislike {
    grid-area: dislike;
    justify-self: end;
  }

  &.profile__rating--like {
    grid-area: like;
    justify-self: start;
  }
`;

export const Container = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 15px;
`;

export const SongListContainer = styled.div`
  width: 90%;
`;

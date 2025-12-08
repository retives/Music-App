import styled from 'styled-components';

export const ContentWrapper = styled.div`
  display: flex;
  flex-direction: column;
  gap: 15px;
  color: white;
`;

export const InputWrapper = styled.div`
  display: flex;
  flex-direction: row;
  align-items: center;
  background-color: #2b2930;
  border-radius: 28px;
  height: 56px;
  padding-right: 10px;

  & > .search-bar-icon {
    margin: 0 5px;
    height: 40px;
    color: white;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    cursor: pointer;
  }

  & > .sort-icon-wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 40px;
    height: 40px;

    & > .sort-icon {
      position: relative;
      display: inline-block;
      cursor: pointer;
      color: white;
      font-size: 24px;
    }

    & > .sort-icon.sort-open {
      color: #b18fff;
    }
  }

  & > .sort-icon-wrapper.sort-open {
    background-color: #cac4d01f;
    border-radius: 20px;
  }

  & > .tooltip {
    width: 230px;
    height: 232px;
    border-radius: 4px;
    background: #444248;
    color: #fff;
    text-align: left;
    padding: 0;
    z-index: 3;
  }
`;

export const Container = styled.div`
  height: 100%;
  width: 100%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  font-family: 'Roboto', sans-serif;
`;

export const SortPlaylistsMenu = styled.div`
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  justify-content: space-evenly;
  column-gap: 10px;

  & > p.sort-group-name {
    font-family: 'Roboto', sans-serif;
    font-size: 12px;
    font-weight: 500;
    line-height: 16px;
    letter-spacing: 0.5px;
    text-align: left;
    color: #aea9b4;
    opacity: 0.8;
    margin: 10px 16px;
    align-self: flex-start;
  }
`;

export const SortPlaylistsMenuOption = styled.p`
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  position: relative;
  padding: 0 24px 0 16px;
  height: 40px;

  & > input[type='radio'] {
    display: none;
  }

  & > label.checkbox-label {
    display: inline;
    cursor: pointer;
    color: white;
  }

  & > label.checkbox-label::after {
    content: '';
    display: inline;
    position: absolute;
    right: 5%;
    width: 24px;
    height: 24px;
    background-color: inherit;
    color: inherit;
  }

  & > input:checked + label.checkbox-label::after {
    content: '✔';
    display: inline;
    color: white;
    width: 24px;
    height: 24px;
  }
`;

export const NoPlaylistsMessage = styled.p`
  font-size: 16px;
  font-weight: 500;
  line-height: 24px;
  letter-spacing: 0.15px;
  text-align: center;
  color: #aea9b4;
  margin-bottom: 12px;
`;

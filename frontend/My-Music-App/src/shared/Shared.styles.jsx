import styled, { css } from 'styled-components';

export const oneLineEllipsis = css`
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
`;

export const flexHorizontalCenter = css`
  display: flex;
  justify-content: center;
  align-items: center;
`;

export const flexVerticalCenter = css`
  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
`;

export const flexColumnCenter = css`
  display: flex;
  flex-direction: column;
  align-items: center;
`;

export const Title = styled.h2`
  color: #fff;
  font-family: Roboto, sans-serif;
  font-size: 22px;
  font-style: normal;
  font-weight: 400;
  line-height: 28px;
`;

export const Subtitle = styled.h3`
  color: #fff;
  font-family: Roboto;
  font-size: 16px;
  font-style: normal;
  font-weight: 500;
  line-height: 24px;
  letter-spacing: 0.15px;
`;

export const BasePlaylistsContainer = styled.section`
  display: grid;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: 12px;
`;

export const Spacer = styled.div`
  ${({ $marginBottom }) =>
    !!$marginBottom && `margin-bottom: ${$marginBottom}px`};
  ${({ $marginTop }) => !!$marginTop && `margin-top: ${$marginTop}px`};
`;

export const BaseButton = styled.button`
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  cursor: pointer;
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

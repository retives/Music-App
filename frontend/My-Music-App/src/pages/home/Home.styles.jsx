import styled from 'styled-components';

export const footerHeight = 64;
export const sidebarWidth = 360;

export const HomeContainer = styled.div`
  margin: 0 auto;
  display: grid;
  grid-template-columns: ${sidebarWidth}px calc(100vw - ${sidebarWidth}px);
  grid-template-rows: auto ${footerHeight}px;
  grid-template-areas:
    'sidebar main'
    'footer footer';

  ${({ $isBlurEnabled }) => $isBlurEnabled && 'filter: blur(5px);'}
`;

export const SidebarContainer = styled.aside`
  grid-area: sidebar;
  min-height: calc(100vh - ${footerHeight}px);
`;

export const MainContainer = styled.main`
  grid-area: main;
  position: relative;
  padding: 56px 112px 80px 80px;
  background: var(--m-3-ref-primary-primary-0, #000);
  height: max-content;
  min-height: calc(100vh - ${footerHeight}px);
  background-image: radial-gradient(
      50% 50% at 50% 50%,
      #293755 0%,
      #0d1927 100%
    ),
    linear-gradient(180deg, #170d2e 0%, #1f192e 100%);
`;

export const FooterContainer = styled.footer`
  grid-area: footer;
  max-height: ${footerHeight}px;
  height: ${footerHeight}px;
`;

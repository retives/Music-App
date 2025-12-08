import styled from 'styled-components';

export const AboutSection = styled.section`
  color: rgb(235, 230, 230);
  margin: 0 auto;
  font-family: Roboto, sans-serif;
`;

export const AboutTitle = styled.h3`
  font-size: 22px;
  line-height: 1.27;
  margin-bottom: 12px;
`;

export const AboutArticle = styled.article`
  font-size: 16px;
  line-height: 1.5;
  letter-spacing: 0.5px;
  & > p {
    margin-bottom: 24px;
  }
  & > p:last-child {
    margin-bottom: 0px;
  }
`;

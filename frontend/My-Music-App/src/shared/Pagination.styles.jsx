import styled from 'styled-components';

export const PaginationControls = styled.div`
  display: flex;
  gap: 24px;
  align-items: center;
  justify-content: center;

  margin-bottom: ${({ $marginBottom }) => $marginBottom};

  & > button {
    cursor: pointer;
    border: none;
    background-color: transparent;
    padding: 12px;
    height: 48px;
    width: 48px;
    font-size: 24px;
  }

  & > button:disabled {
    cursor: not-allowed;
    color: #9b9b9b;
  }
  & > button:enabled {
    color: #fff;
  }
`;

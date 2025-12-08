import styled from 'styled-components';
import { COLOR_CONSTANTS } from '../constants';

const { errorColor, regularColor, accentColor, titleColor, secondColor } =
  COLOR_CONSTANTS;

export const SignInPage = styled.section`
  font-family: Roboto, sans-serif;
`;

export const SignInTitle = styled.h2`
  padding: 20px 30px;
  margin-bottom: 20px;
  color: ${titleColor};
  font-size: 22px;
  line-height: 1.27;
`;

export const SignInForm = styled.form`
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 32px;
  color: ${secondColor};
`;

export const InputsList = styled.ul`
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
`;

export const InputItem = styled.li`
  display: block;
  max-width: 320px;
`;

export const InputWrapper = styled.div`
  position: relative;
  width: 320px;
  height: 54px;
  border-radius: 4px;
  border: 1px solid ${regularColor};
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0px 15px;
  & > input:-webkit-autofill,
  & > input:-webkit-autofill:hover,
  & > input:-webkit-autofill:focus,
  & > input:-webkit-autofill:active {
    -webkit-background-clip: text;
    -webkit-text-fill-color: #ffffff;
    box-shadow: inset 0 0 20px 20px #23232329;
    font-size: 16px;
    color: ${secondColor};
    letter-spacing: 0.5px;
  }
`;

export const InputLabel = styled.label`
  position: absolute;
  top: -11px;
  left: 15px;
  padding: 4px;
  border-radius: 5px;
  background-color: rgb(29, 27, 32);
  font-size: 12px;
  display: inline-block;
  color: ${titleColor};
`;

export const InputBox = styled.input`
  width: 100%;
  font-size: 16px;
  color: ${secondColor};
  letter-spacing: 0.5px;
`;

export const ClearingButton = styled.button`
  border: none;
  background: none;
  color: white;
  cursor: pointer;
`;

export const ErrorDescription = styled.p`
  min-height: 16px;
  max-width: 320px;
  width: 100%;
  color: ${errorColor};
  font-size: 12px;
  line-height: 1.33;
  padding: 0px 10px;
`;

export const CheckboxBlock = styled.div`
  display: flex;
  align-items: center;
  padding: 12px;
  gap: 16px;
`;

export const Checkbox = styled.input`
  width: 18px;
  height: 18px;
  accent-color: ${accentColor};
  cursor: pointer;
`;

export const CheckboxDescription = styled.label`
  color: ${secondColor};
  height: 24px;
  font-size: 16px;
  line-height: 24px;
  letter-spacing: 0.5px;
  cursor: pointer;
`;

export const SignInSignUpBlock = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 32px;
`;

export const SignInButton = styled.button`
  cursor: pointer;
  width: 224px;
  height: 40px;
  border-radius: 20px;
  background-color: ${accentColor};
  font-size: 14px;
  font-weight: 500;
  border: none;
  ${(props) =>
    props.disabled &&
    `
      background-color: rgba(230, 224, 233, 0.12);
      opacity: 0.38;
      color: ${secondColor};
      cursor: initial;
    `}
`;

export const NavDescription = styled.p`
  font-size: 12px;
  line-height: 1.33;
  color: ${secondColor};
`;

export const NavWrapper = styled.nav`
  > a {
    font-size: 14px;
    font-weight: 500;
    line-height: 1.42;
    padding: 10px 12px;
    color: ${accentColor};
    text-decoration: none;
  }
`;

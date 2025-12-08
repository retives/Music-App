import React from 'react';
import PropTypes from 'prop-types';
import { IoMdCloseCircleOutline } from 'react-icons/io';

import {
  ClearingButton,
  ErrorDescription,
  InputBox,
  InputItem,
  InputLabel,
  InputWrapper,
} from './SignUp.styled';

function SignUpFormInput({
  label,
  type,
  name,
  value,
  onChange,
  resetDetails,
  signUpErrors,
}) {
  return (
    <InputItem className='input-item'>
      <InputWrapper>
        <InputLabel>{label}</InputLabel>
        <InputBox
          data-testid={name}
          type={type}
          name={name}
          value={value}
          onChange={onChange}
          className={'signUp__' + name + 'Input'}
        ></InputBox>
        <ClearingButton
          data-testid={name + 'Clear'}
          type='reset'
          onClick={() => resetDetails(name)}
        >
          <IoMdCloseCircleOutline size={24} />
        </ClearingButton>
      </InputWrapper>
      <ErrorDescription data-testid={name + 'Error'}>
        {signUpErrors}
      </ErrorDescription>
    </InputItem>
  );
}

SignUpFormInput.propTypes = {
  label: PropTypes.string,
  type: PropTypes.string,
  name: PropTypes.string,
  value: PropTypes.string,
  onChange: PropTypes.func,
  resetDetails: PropTypes.func,
  signUpErrors: PropTypes.string,
};

export default SignUpFormInput;

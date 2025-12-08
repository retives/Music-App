import React, { useState, useEffect } from 'react';
import SignUpFormInput from './SignUpFormInput';
import { validate } from './SignUpValidation';
import { Link, useNavigate } from 'react-router-dom';
import axios from 'axios';
import { constants } from './constants';
import { isLoggedIn } from '../../RedirectAuthenticatedUsers/AuthenticatedUsers';
import paths from '../../router/paths';
import { SIGNUP_URL } from '../../store/constants';

import {
  InputsList,
  NavDescription,
  NavWrapper,
  SignUpButton,
  SignUpForm,
  SignUpPage,
  SignInSignUpBlock,
  SignUpTitle,
} from './SignUp.styled';

function SignUp() {
  const navigate = useNavigate();
  const backendErrors = {
    nicknameExistingError: false,
    emailExistingError: false,
    emailDomainError: false,
    emailInvalidError: false,
  };
  const initialValues = {
    nickname: '',
    email: '',
    password: '',
    confirmPassword: '',
  };
  const [signUpValues, setSignUpValues] = useState(initialValues);
  const [signUpErrors, setSignUpErrors] = useState({});
  const [disableButton, setDisableButton] = useState(1);
  const [loggedStatus, setLoggedStatus] = useState(false);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setSignUpValues({ ...signUpValues, [name]: value });
  };

  const resetDetails = (name) => {
    setSignUpValues({ ...signUpValues, [name]: '' });
    setSignUpErrors({ ...signUpErrors, [name]: '' });
  };

  useEffect(() => {
    isLoggedIn(loggedStatus, setLoggedStatus, navigate);
  }, [loggedStatus, setLoggedStatus, navigate]);

  useEffect(() => {
    if (
      signUpValues.nickname &&
      signUpValues.email &&
      signUpValues.password &&
      signUpValues.confirmPassword
    )
      setDisableButton(0);
    else setDisableButton(1);
  }, [
    signUpValues.nickname,
    signUpValues.email,
    signUpValues.password,
    signUpValues.confirmPassword,
  ]);
  const handleSubmit = (e) => {
    e.preventDefault();
    setSignUpErrors(validate(signUpValues, backendErrors));
    fetchAPIData();
  };

  const backendErrorsValidate = (errorsArray) => {
    errorsArray.forEach((element) => {
      switch (element) {
        case constants.emailDomainErrorElement:
          backendErrors.emailDomainError = true;
          break;
        case constants.emailExistingErrorElement:
          backendErrors.emailExistingError = true;
          break;
        case constants.emailInvalidErrorElement:
          backendErrors.emailInvalidError = true;
          break;
        case constants.nicknameExistingErrorElement:
          backendErrors.nicknameExistingError = true;
          break;
        default:
          break;
      }
    });
    setSignUpErrors(validate(signUpValues, backendErrors));
  };

  const fetchAPIData = async () => {
    const userData = {
      user: {
        email: signUpValues.email,
        nickname: signUpValues.nickname,
        password: signUpValues.password,
        password_confirmation: signUpValues.confirmPassword,
      },
    };

    try {
      await axios.post(SIGNUP_URL, userData);
      navigate(paths.signIn);
    } catch (error) {
      const errorsArray = error.response.data.errors.details;
      backendErrorsValidate(errorsArray);
    }
  };

  return (
    <SignUpPage className='signUp'>
      <SignUpTitle className='signUp__title' data-testid='signun'>
        Sign Up
      </SignUpTitle>
      <SignUpForm className='signUp__form' onSubmit={handleSubmit}>
        <InputsList className='signUp__inputsList'>
          <SignUpFormInput
            label='Nickname'
            type='text'
            name='nickname'
            value={signUpValues.nickname}
            onChange={handleChange}
            resetDetails={resetDetails}
            signUpErrors={signUpErrors.nickname}
          />
          <SignUpFormInput
            label='Email'
            type='text'
            name='email'
            value={signUpValues.email}
            onChange={handleChange}
            resetDetails={resetDetails}
            signUpErrors={signUpErrors.email}
          />
          <SignUpFormInput
            label='Password'
            type='password'
            name='password'
            value={signUpValues.password}
            onChange={handleChange}
            resetDetails={resetDetails}
            signUpErrors={signUpErrors.password}
          />
          <SignUpFormInput
            label='Password Confirmation'
            type='password'
            name='confirmPassword'
            value={signUpValues.confirmPassword}
            onChange={handleChange}
            resetDetails={resetDetails}
            signUpErrors={signUpErrors.confirmPassword}
          />
        </InputsList>
        <SignInSignUpBlock>
          <SignUpButton
            className='signUp__submitButton'
            id='submit-confirm'
            type='submit'
            disabled={disableButton}
          >
            Sign Up
          </SignUpButton>
          <NavDescription>Already have an account?</NavDescription>
          <NavWrapper>
            <Link to={paths.signIn} className='signUp__toSignInNavigationlink'>
              Sign in
            </Link>
          </NavWrapper>
        </SignInSignUpBlock>
      </SignUpForm>
    </SignUpPage>
  );
}

export default SignUp;

import React, { useCallback, useEffect, useState } from 'react';
import { IoMdCloseCircleOutline } from 'react-icons/io';
import { useFormik } from 'formik';
import { SignInSchema } from './schemas/SignInSchema';
import { BsFillExclamationCircleFill } from 'react-icons/bs';
import { Link, useNavigate } from 'react-router-dom';

import { useDispatch, useSelector } from 'react-redux';
import {
  clearLoginError,
  setIsRemembered,
} from '../../store/user/user.reducer';
import { loginUser } from '../../store/user/user.thunks';
import {
  isAuthenticatedSelector,
  loginErrorSelector,
} from '../../store/user/user.selector';

import { toast } from 'react-toastify';
import { baseToastConfig, LoginSuccessMessage } from '../../shared/Toasts';
import paths from '../../router/paths';
import {
  Checkbox,
  CheckboxBlock,
  CheckboxDescription,
  ClearingButton,
  ErrorDescription,
  InputBox,
  InputItem,
  InputLabel,
  InputsList,
  InputWrapper,
  NavDescription,
  NavWrapper,
  SignInButton,
  SignInForm,
  SignInPage,
  SignInSignUpBlock,
  SignInTitle,
} from './SignIn.styled';
import { COLOR_CONSTANTS } from '../constants';

function SignIn() {
  const dispatch = useDispatch();

  const isAuthenticated = useSelector(isAuthenticatedSelector);
  const loginError = useSelector(loginErrorSelector);

  const [isSubmitted, setIsSubmitted] = useState(false);

  const navigate = useNavigate();
  const toastId = React.useRef(null);
  const notify = useCallback(() => {
    toastId.current = toast(<LoginSuccessMessage />, {
      ...baseToastConfig,
      type: toast.TYPE.SUCCESS,
      autoClose: 500,
    });
  }, []);

  const onSubmit = () => {
    const userData = {
      email: values.email,
      password: values.password,
    };
    setIsSubmitted(true);
    loginError && dispatch(clearLoginError()); // Clearing error from state befor next login attempt
    dispatch(loginUser(userData));
  };

  const { errorColor, regularColor, titleColor } = COLOR_CONSTANTS;

  const {
    values,
    errors,
    touched,
    handleBlur,
    handleSubmit,
    isValid,
    setFieldValue,
    setFieldError,
    setErrors,
  } = useFormik({
    initialValues: {
      email: '',
      password: '',
    },
    validationSchema: SignInSchema,
    onSubmit,
  });

  const clearFunc = (name) => {
    setFieldValue(name, '');
  };

  // Altering default change handler coz we need to clear errors and loginError if user is typing and this errors comes from unsuccessful login
  const handleFormChange = (event) => {
    const fieldName = event.target.name;
    const fieldValue = event.target.value;
    if (isSubmitted && loginError) {
      dispatch(clearLoginError());
      setIsSubmitted(false);
      setErrors({});
    }
    setFieldValue(fieldName, fieldValue);
  };

  // Thunk results handling
  useEffect(() => {
    // TODO: Get possible errors from backend team
    if (loginError) {
      errors.email = loginError;
      setFieldError(errors.email);
    }
  }, [loginError, errors, setFieldError]);

  useEffect(() => {
    if (isAuthenticated) {
      notify();
      navigate('/');
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isAuthenticated, notify]); // Navigate is not a dependency, it remains unchanged from the initialization of router.

  return (
    <SignInPage className='signIn'>
      <SignInTitle className='signIn__title' data-testid='signin'>
        Sign In
      </SignInTitle>
      <SignInForm
        className='signIn__form'
        onSubmit={handleSubmit}
        autoComplete='on'
      >
        <div>
          <InputsList className='signIn__inputsList'>
            <InputItem>
              <InputWrapper
                style={{
                  borderColor: `${
                    errors.email && touched.email ? errorColor : regularColor
                  }`,
                }}
              >
                <InputLabel
                  style={{
                    color: `${
                      errors.email && touched.email ? errorColor : titleColor
                    }`,
                  }}
                  htmlFor='inputbox'
                >
                  Email
                </InputLabel>
                <InputBox
                  className='signIn__emailInput'
                  value={values.email}
                  onChange={handleFormChange}
                  type='email'
                  name='email'
                  onBlur={handleBlur}
                  data-testid='emailtest'
                />
                {errors.email && touched.email ? (
                  <BsFillExclamationCircleFill size={24} color={errorColor} />
                ) : (
                  <ClearingButton
                    type='button'
                    data-testid='closetest1'
                    onClick={() => clearFunc('email')}
                  >
                    <IoMdCloseCircleOutline size={24} />
                  </ClearingButton>
                )}
              </InputWrapper>
              <ErrorDescription>{errors.email}</ErrorDescription>
            </InputItem>
            <InputItem>
              <InputWrapper
                style={{
                  borderColor: `${
                    errors.password && touched.password
                      ? errorColor
                      : regularColor
                  }`,
                }}
              >
                <InputLabel
                  style={{
                    color: `${
                      errors.password && touched.password
                        ? errorColor
                        : titleColor
                    }`,
                  }}
                  htmlFor='password'
                >
                  Password
                </InputLabel>
                <InputBox
                  className='signIn__passwordInput'
                  id='password-label'
                  value={values.password}
                  onChange={handleFormChange}
                  onBlur={handleBlur}
                  name='password'
                  data-testid='passwordtest'
                />
                {errors.password && touched.password ? (
                  <BsFillExclamationCircleFill size={24} color={errorColor} />
                ) : (
                  <ClearingButton
                    type='button'
                    data-testid='closetest2'
                    onClick={() => clearFunc('password')}
                  >
                    <IoMdCloseCircleOutline size={24} />
                  </ClearingButton>
                )}
              </InputWrapper>
              <ErrorDescription>{errors.password}</ErrorDescription>
            </InputItem>
          </InputsList>

          <CheckboxBlock>
            <Checkbox
              className='signIn__checkbox'
              type='checkbox'
              id='checkbox'
              name='checkbox'
              onClick={(e) => {
                dispatch(setIsRemembered(e.target.checked));
              }}
            />
            <CheckboxDescription htmlFor='checkbox'>
              Remember me
            </CheckboxDescription>
          </CheckboxBlock>
        </div>

        <SignInSignUpBlock>
          <SignInButton
            className='signIn__submitButton'
            type='submit'
            disabled={!isValid}
          >
            Sign In
          </SignInButton>
          <NavDescription>Don't have a account yet?</NavDescription>
          <NavWrapper>
            <Link className='signIn__toSignUpNavigationLink' to={paths.signUp}>
              Sign Up
            </Link>
          </NavWrapper>
        </SignInSignUpBlock>
      </SignInForm>
    </SignInPage>
  );
}

export default SignIn;

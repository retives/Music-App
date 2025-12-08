import React, { useEffect, useRef } from 'react';
import { AboutSection, AboutTitle, AboutArticle } from './About.styles';
import { useDispatch, useSelector } from 'react-redux';
import { fetchAbout } from '../../store/aboutPage/aboutPage.thunks';
import { aboutPageSelector } from '../../store/aboutPage/aboutPage.selector';

function About() {
  const dispatch = useDispatch();
  const { title, body } = useSelector(aboutPageSelector);
  const articleRef = useRef(null);

  useEffect(() => {
    dispatch(fetchAbout());
    // eslint-disable-next-line
  }, []);

  useEffect(() => {
    if (articleRef.current) {
      articleRef.current.innerHTML = '';
      articleRef.current.insertAdjacentHTML(
        'beforeend',
        body ?? 'Page is still under construction...'
      );
    }
  }, [body]);

  return (
    <AboutSection>
      <AboutTitle>{title ?? 'About us'}</AboutTitle>
      <AboutArticle ref={articleRef} />
    </AboutSection>
  );
}

export default About;

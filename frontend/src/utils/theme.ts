import { createTheme, type Theme } from '@mui/material/styles';
import { Settings } from '../models';

const makeTheme = function (settings: Settings): Theme {
  const theme: Theme = createTheme({
    palette: {
      mode: settings.mode,
      primary: {
        main: '#00bcd4',
        light: '#4dd0e1',
        dark: '#0097a7',
      },
      secondary: {
        main: '#e91e63',
        light: '#f06292',
        dark: '#c2185b',
      },
      background: {
        default: settings.mode === 'dark' ? '#0a0a0a' : '#fafafa',
      },
    },
    typography: { fontSize: settings.fontSize },
  });

  return theme;
};

export const getWindowSize = function (fontSize: number): { width: number; height: number } {
  // returns window size in EM units
  return {
    width: window.innerWidth / fontSize,
    height: window.innerHeight / fontSize,
  };
};

export default makeTheme;

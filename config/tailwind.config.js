const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      colors: {
        'major': "#fb8500",
        'minor': "#ffb703", 
        'darkBlue': '#14213d',
        'hoverGray': '#f8f9fa',
        'chosenOrange': '#ffc300',
        'bgGray': '#f8f9fa'
      },
      spacing: {
        '-1px': '-1px',
        '-2px': '-2px',
        '-3px': '-3px',
        '-8px': '-8px',
        '-10px': '-10px',
        '70': '70%',
        '80': '80%',
        '85': '85%',
        '90': '90%',
        '93': '93%',
        '95': '95%'
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}

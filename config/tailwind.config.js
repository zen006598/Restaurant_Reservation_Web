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
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
  ]
}

module.exports =  {
  plugins: [
    require('postcss-smart-import')({
      path: [
        'templates'
      ]
    }),
    require('postcss-cssnext')
  ]
};

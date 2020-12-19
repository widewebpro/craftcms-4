const webpack = require('webpack');
const path = require('path');
const glob = require('glob');
const globAll = require('glob-all');
const StyleLintPlugin = require('stylelint-webpack-plugin')
const OptimizeCssAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const SWPrecacheWebpackPlugin = require('sw-precache-webpack-plugin')
const WebpackShellPlugin = require('webpack-shell-plugin');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlCriticalWebpackPlugin = require("html-critical-webpack-plugin");
const PurifyCSSPlugin = require('purifycss-webpack');
const webpackConfig = {
  entry: {
    app: path.join(__dirname, 'templates/index.js')
  },
  output: {
    path: path.join(__dirname, 'web/compiled'),
    publicPath: '/compiled/',
    filename: '[name].js'
  },
  devtool: 'cheap-module-eval-source-map',
  stats: {
    entrypoints: false,
    children: false
  },
  module: {
    rules: [
      {
        enforce: 'pre',
        test: /\.js$/,
        loader: 'eslint-loader',
        exclude: /node_modules/
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
        options: {
          presets: ['es2015']
        }
      },
      { test: /\.js$/,
        loader: 'imports-loader?define=>false'
      },
      {
        test: /\.css$/,
        use: [
          MiniCssExtractPlugin.loader,
          {
            loader: 'css-loader',
            options: {
              importLoaders: 1,
              sourceMap: true,
              url: false
            }
          },
          {
            loader: 'postcss-loader'
          }
        ]
      },
      {
        test: /\.(jpg|png|gif|svg|woff|ttf|otf|woff2|tiff|webp|jpeg|eot)$/,
        loader: 'file-loader'
      }
    ]
  },
  resolve: {
    modules: [
      'node_modules',
      path.resolve(__dirname, 'templates')
    ]
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: path.join(__dirname, 'templates/layout/base-template.twig'),
      filename: path.join(__dirname, 'templates/layout/main.twig')
    })
  ],
  optimization: {
    splitChunks: {
      cacheGroups: {
        vendor: {
          test: /node_modules/,
          name: 'vendor',
          chunks: 'all',
          priority: 1000,
          enforce: true
        }
      }
    }
  }
};
if (process.env.NODE_ENV === 'production') {
  webpackConfig.output.filename = '[name].[chunkhash].js';
  webpackConfig.plugins.push(
      new webpack.LoaderOptionsPlugin({ options: {} })
  )
    webpackConfig.plugins.push(
        new MiniCssExtractPlugin({
            filename: '[name].[chunkhash].css'
        }),
    );
  webpackConfig.plugins.push(
      new StyleLintPlugin({
        files: ['templates/**/*.css'],
        failOnError: true,
        configBasedir: __dirname
      })
  );

  webpackConfig.plugins.push(
      new OptimizeCssAssetsPlugin({
        cssProcessorOptions: {
          discardComments: { removeAll: true },
          zindex: false
        }
      })
  );

} else {
  webpackConfig.plugins.push(
      new MiniCssExtractPlugin({
        filename: '[name].css'
      }),
  );
  webpackConfig.plugins.push(
      new StyleLintPlugin({
        files: ['templates/**/*.css'],
        failOnError: false,
        configBasedir: __dirname
      })
  )
}
module.exports = webpackConfig;
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const VueLoaderPlugin = require('vue-loader/lib/plugin');

const resolve = require('path').resolve;

var merge = require("webpack-merge");
var webpack = require("webpack");

var env = process.env.NODE_ENV || "development";
var production = env === "production";

var node_modules_dir = "./node_modules"

var plugins = [
  new MiniCssExtractPlugin(),
  new VueLoaderPlugin()
]

if (production) {

}
else {
  plugins.push(
    new webpack.EvalSourceMapDevToolPlugin()
  );
}

var common = {
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: [node_modules_dir],
        loader: "babel-loader",
        options: {
          presets: ["@babel/preset-env"]
        }
      },
      {
        test: /\.scss$/,
        use: [
          {
            loader: 'style-loader',
          },
          {
            loader: 'postcss-loader',
            options: {
              plugins() {
                return [
                  require("precss"),
                  require("autoprefixer")
                ];
              }
            }
          },
          {
            loader: 'sass-loader'
          }
        ]
      },
      {
        test: /\.(png|jpg|gif|svg)$/,
        loader: `file-loader?name=/app/assets/[name].[ext]`
      },
      {
        test: /\.(ttf|otf|eot|svg|woff2?)$/,
        loader: `file-loader?name=/app/assets/[name].[ext]`
      },
      {
        test: /\.css$/,
        use: [
          'vue-style-loader',
          'css-loader'
        ]
      },
      {
        test: /\.vue$/,
        loader: 'vue-loader'
      }
    ]
  },
  plugins: plugins
};

module.exports = [
  merge(common, {
    devServer: {
      headers: {
        'Access-Control-Allow-Origin': '*'
      },
      port: 8080
    },
    entry: [
      __dirname + "/app/app.scss",
      __dirname + "/app/app.js"
    ],
    output: production
    ? {
      path: resolve(__dirname, "../priv/static/js"),
      filename: "app.js",
      publicPath: "/js"
    }
    : {
      path: resolve(__dirname, 'public'),
      filename: 'app.js',
      publicPath: 'http://localhost:8080/'
    },
    resolve: {
      modules: [
        node_modules_dir,
        __dirname + "/app"
      ]
    },
    optimization: production
    ? {
      minimize: production
    }
    : {
      minimize: false
    }
  })
];

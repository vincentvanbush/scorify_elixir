const path = require("path");
const webpack = require("webpack");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const UglifyJsPlugin = require("uglifyjs-webpack-plugin");
const DEVELOPMENT = "development";

const env = process.env.NODE_ENV || DEVELOPMENT;
const dev = env === DEVELOPMENT;

module.exports = {
    entry: "./src/app.js",
    output: Object.assign({ filename: "app.js" },
        dev
            ? 
                {
                    path: path.resolve(__dirname, "public"),
                    publicPath: "/js"
                }
            :
                {
                    path: path.resolve(__dirname, "../priv/static/js"),
                    // publicPath: "http://localhost:8081/"
                    publicPath: "/js"
                } 
    ),
    mode: env,
    module: {
        rules: [
            {
                test: /\.jsx|\.js$/,
                exclude: /node_modules/,
                loader: "babel-loader",
                options: {
                    presets: ["@babel/preset-env", "@babel/preset-react"]
                }
                // OR
                // use: {
                //     loader: "babel-loader",
                //     options: {
                //         presets: ["@babel/preset-env", "@babel/preset-react"]
                //     }
                // },
            },
            {
                test: /\.less$/,
                use: [
                    dev 
                        ? { loader: "style-loader" }
                        : { loader: MiniCssExtractPlugin.loader, /* options: { publicPath: "../css" } */ },
                    { loader: "css-loader" },
                    { loader: "less-loader" }
                ]
            },
            {
                test: /\.(pdf|jpg|png|gif|svg|ico)$/,
                use: [
                    dev
                        ? { loader: "url-loader" }
                        : {
                            loader: "file-loader",
                            options: {
                                name: "/../assets/[name]-[hash:8].[ext]"
                                // name: "[path][name]-[hash:8].[ext]"
                            },
                        }
                ]
            }
        ]
    },
    plugins: [
    //     new webpack.DefinePlugin({
    //         "process.env": {
    //             NODE_ENV: JSON.stringify(env)
    //         }
    //     })
        new MiniCssExtractPlugin({
            filename: "../css/[name].css",
            chunkFilename: "[id].css"
        })
    ],
    // optimization: {
    //     minimizer: [
    //         new UglifyJsPlugin({
    //             test: /\.jsx$/i
    //         })
    //     ]
    // }
};

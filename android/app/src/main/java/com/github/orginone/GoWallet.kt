package com.github.orginone

import android.util.Log
import com.google.gson.Gson
import walletapi.*
import java.util.*

class GoWallet {
    companion object {

        private val gson = Gson()

        private val util = Util()

        //此处填写go服务的域名
        fun getUtil(): Util {
            util.node = "http://eth8080.jx868.com/549788"
            return util
        }


        /**
         *  创建助记词
         * @param mnemLangType Int  1 中文  2 英文
         * @return String
         */
        fun createMnem(mnemLangType: Int): String {
            return when (mnemLangType) {
                1 -> Walletapi.newMnemonicString(1, 160)
                2 -> Walletapi.newMnemonicString(0, 128)
                else -> Walletapi.newMnemonicString(1, 160)
            }
        }


        fun getPrikey(chain: String, mnem: String): String {
            try {
                val hdWallet = Walletapi.newWalletFromMnemonic_v2(chain, mnem)
                val prikey = hdWallet.newKeyPriv(0)
                return Walletapi.byteTohex(prikey)
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return ""
        }

        /**
         *
         * @param chain String   主链
         * @param mnem String    助记词
         * @return HDWallet?
         */
        @JvmStatic
        fun getHDWallet(chain: String, mnem: String): HDWallet? {
            try {
                return Walletapi.newWalletFromMnemonic_v2(chain, mnem)
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return null
        }

        /**
         * 公钥转地址
         * @param chain String   主链
         * @param pub  String  公钥
         * @return String?
         */
        fun pubToAddr(chain: String, pub: String): String? {
            try {
                return Walletapi.pubToAddress_v2(chain, Walletapi.hexTobyte(pub))
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return null
        }

        /**
         * 私钥转地址
         * @param chain String   主链
         * @param priv String    私钥
         * @return String
         */
        fun privToAddr(chain: String, priv: String): String? {
            try {
                val pub = Walletapi.privkeyToPub_v2(chain, Walletapi.hexTobyte(priv))
                return Walletapi.pubToAddress_v2(chain, pub)
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return null
        }

        fun priToPub(chain: String, priv: String): ByteArray? {
            try {
                return Walletapi.privkeyToPub_v2(chain, Walletapi.hexTobyte(priv))
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return null
        }

        fun byteTohex(byteArray: ByteArray): String {
            return Walletapi.byteTohex(byteArray)
        }

        /**
         * 获取余额
         * @param chain String    主链名称，例如：“BTC”
         * @param tokenSymbol String   token名称，例如ETH下的“YCC”
         * @param goNoderUrl String    服务器节点
         * 服务器挂掉{"id":1,"result":null,"error":"cointype EEE no support"}
         */
        private fun getbalance(
            addresss: String,
            chain: String,
            tokenSymbol: String,
        ): String? {
            try {

                val balance = WalletBalance()
                balance.cointype = chain
                balance.address = addresss
                balance.tokenSymbol = tokenSymbol
                balance.util = getUtil()
                val getbalance = Walletapi.getbalance(balance)
                return Walletapi.byteTostring(getbalance)
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            }
            return null
        }

        /**
         * 获取交易记录
         * @param chain String  主链名称，例如：“BTC”
         * @param tokenSymbol String   token名称，例如ETH下的“YCC”
         * @param type Long         交易账单类型（0全部 1入账，2出账）
         * @param page Long         页数
         * @param count Long        一页请求的条数
         * @param goNoderUrl String
         * @return String
         */
        fun getTranList(
            addr: String,
            chain: String,
            tokenSymbol: String,
            type: Long,
            page: Long,
            count: Long
        ): String? {
            try {

                val walletQueryByAddr = WalletQueryByAddr()
                val queryByPage = QueryByPage()
                queryByPage.cointype = chain
                queryByPage.tokenSymbol = if (chain == tokenSymbol) "" else tokenSymbol
                queryByPage.address = addr
                queryByPage.count = count
                queryByPage.direction = 0
                queryByPage.index = page
                if (!type.equals(0)) {
                    queryByPage.type = type
                }
                walletQueryByAddr.queryByPage = queryByPage
                walletQueryByAddr.util = getUtil()
                val transaction = Walletapi.queryTransactionsByaddress(walletQueryByAddr)
                return Walletapi.byteTostring(transaction)
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            }

            return null
        }


        /**
         *获取单笔交易详情
         * @param chain String   主链名称，例如：“BTC”
         * @param tokenSymbol String   token名称，例如ETH下的“YCC”
         * @param txid String   交易txid
         * @param goNoderUrl String   服务器节点
         * @return String?
         */
        private fun getTranByTxid(
            chain: String,
            tokenSymbol: String,
            txid: String,
            goNoderUrl: String
        ): String? {
            try {

                val walletQueryByTxid = WalletQueryByTxid()
                walletQueryByTxid.cointype = chain
                walletQueryByTxid.tokenSymbol = if (chain == tokenSymbol) "" else tokenSymbol
                walletQueryByTxid.txid = txid
                walletQueryByTxid.util = getUtil()
                val transaction =
                    Walletapi.queryTransactionByTxid(walletQueryByTxid)
                return Walletapi.byteTostring(transaction)
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            }
            return null
        }

        /**
         * 创建交易
         * @param cointype String  主链名称，例如：“BTC”
         * @param from String
         * @param to String
         * @param amount Double
         * @param fee Double
         * @param note String
         * @param tokensymbol String
         * @return String?
         */
        fun createTran(
            chain: String, fromAddr: String, toAddr: String, amount: Double, fee: Double,
            note: String, tokensymbol: String
        ): String? {
            try {

                val walletTx = WalletTx()
                walletTx.cointype = chain
                walletTx.tokenSymbol = if (chain == tokensymbol) "" else tokensymbol
                val txdata = Txdata()
                txdata.amount = amount
                txdata.fee = fee
                txdata.from = fromAddr
                txdata.note = note
                txdata.to = toAddr
                walletTx.tx = txdata
                walletTx.util = getUtil()
                val createRawTransaction = Walletapi.createRawTransaction(walletTx)
                val createRawTransactionStr = Walletapi.byteTostring(createRawTransaction)
                Log.v("tag", "创建交易: $createRawTransactionStr")
                return createRawTransactionStr
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            }
            return null
        }


        /**
         * 签名交易
         * @param chain String     主链名称，例如：“BTC”
         * @param unSignData String   创建交易后的数据（result）
         * @param priv String     私钥
         * @return String?
         */
        fun signTran(chain: String, unSignData: String, priv: String): String? {
            try {
                val signData = SignData()
                signData.cointype = chain
                signData.data = Walletapi.stringTobyte(unSignData)
                signData.privKey = priv
                val signRawTransaction =
                    Walletapi.signRawTransaction(signData)
                Log.v("tag", "签名交易: $signRawTransaction")
                return signRawTransaction
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            }
            return null
        }

        //unSignData只有dapp签名（16进制）的时候才是hexTobyte，普通转账是stringTobyte
        fun signTran(chain: String, unSignData: ByteArray, priv: String, addressId: Int): String? {
            try {
                val signData = SignData()
                signData.cointype = chain
                signData.data = unSignData
                signData.privKey = priv
                if (addressId != -1) {
                    signData.addressID = addressId
                }
                val signRawTransaction =
                    Walletapi.signRawTransaction(signData)
                Log.v("tag", "签名交易: $signRawTransaction")
                return signRawTransaction
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            }
            return null
        }

        fun signTran(chain: String, unSignData: ByteArray, priv: String): String? {
            try {
                val signData = SignData()
                signData.cointype = chain
                signData.data = unSignData
                signData.privKey = priv
                val signRawTransaction =
                    Walletapi.signRawTransaction(signData)
                Log.v("tag", "签名交易: $signRawTransaction")
                return signRawTransaction
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            }
            return null
        }

        fun signTxGroup(
            execer: String?,
            createTx: String,
            txPriv: String,
            feePriv: String,
            btyfee: Double,
            addressId: Int
        ): String? {
            try {
                val gWithoutTx = GWithoutTx()
                gWithoutTx.noneExecer = execer
                gWithoutTx.feepriv = feePriv //代扣手续费的私钥
                gWithoutTx.txpriv = txPriv
                gWithoutTx.rawTx = createTx
                //bty的推荐手续费设置
                gWithoutTx.fee = btyfee
                if (addressId != -1) {
                    gWithoutTx.txAddressID = addressId
                    gWithoutTx.feeAddressID = addressId
                    gWithoutTx.execerAddressID = addressId
                }
                val txResp = Walletapi.coinsWithoutTxGroup(gWithoutTx)
                return txResp.signedTx
            } catch (e: Exception) {
                e.printStackTrace()
            }
            return null
        }

        /**
         * 发送交易
         * @param chain String   主链名称，例如：“BTC”
         * @param signData String    token名称，例如ETH下的“YCC”
         * @param tokenSymbol String   签名后的数据
         * @param goNoderUrl String    服务器节点
         * @return String?
         */
        fun sendTran(
            chain: String,
            signData: String,
            tokenSymbol: String,
            util: Util = getUtil()
        ): String? {
            try {

                val sendTx = WalletSendTx()
                sendTx.cointype = chain
                sendTx.signedTx = signData
                sendTx.tokenSymbol = tokenSymbol
                sendTx.util = util
                val sendRawTransaction =
                    Walletapi.byteTostring(Walletapi.sendRawTransaction(sendTx))
                Log.v("tag", "发送交易: $sendRawTransaction")
                return sendRawTransaction
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            }
            return null
        }

        /**
         * 平行链构造+签名
         * @param txpriv String         本地BTY的私钥
         * @param amount Double         数量
         * @param note String           备注
         * @param feePriv String      	代扣手续费的私钥
         * @param tokenfee Double       代扣多少coins作为手续费，例如：0.001
         * @param tokenfeeAddr String   代扣的手续费接收地址
         * @param fee Double            代扣BTY作为整个交易的手续费，单笔交易最低0.001，交易组建议0.003
         * @return GsendTxResp
         */
        fun pcTran(
            to: String,
            tokenSymbol: String,
            execer: String,
            txpriv: String,
            amount: Double,
            note: String,
            feePriv: String,
            coinsForFee: Boolean,
            tokenfee: Double,
            tokenfeeAddr: String,
            fee: Double
        ): GsendTxResp {
            val gsendTx = GsendTx()
            gsendTx.to = to
            gsendTx.tokenSymbol = tokenSymbol
            gsendTx.execer = execer
            gsendTx.txpriv = txpriv
            gsendTx.amount = amount
            gsendTx.note = note
            gsendTx.feepriv = feePriv
            gsendTx.coinsForFee = coinsForFee
            gsendTx.tokenFee = tokenfee
            gsendTx.tokenFeeAddr = tokenfeeAddr
            gsendTx.fee = fee
            val gsendTxResp = Walletapi.coinsTxGroup(gsendTx)
            return gsendTxResp
        }

        /**
         * 校验密码(true :密码校验成功)
         * @param password String    没加密的密码
         * @param passwdHash String  加密后的哈希密码
         * @return Boolean
         */
        fun checkPasswd(password: String, passwdHash: String): Boolean {
            var checked = false
            try {
                checked = Walletapi.checkPasswd(password, passwdHash)
                return checked
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            }
            return checked
        }

        /**
         *  密码加密
         * @param password String   密码
         * @return ByteArray?
         */
        fun encPasswd(password: String): ByteArray? {
            try {
                return Walletapi.encPasswd(password)
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            }
            return null
        }

        /**
         * 把加密的密码转换成哈希密码
         * @param password ByteArray   加密后的密码
         * @return String?
         */

        fun passwdHash(password: ByteArray): String? {
            try {
                return Walletapi.passwdHash(password)
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            }
            return null
        }


        /**
         * 加密助记词
         * @param password ByteArray  加密后的密码
         * @param mnem String    助记词
         * @return String?
         */
        fun encMenm(encPasswd: ByteArray, seed: String): String? {
            try {
                val bSeed = Walletapi.stringTobyte(seed)
                val seedEncKey = Walletapi.seedEncKey(encPasswd, bSeed)
                return Walletapi.byteTohex(seedEncKey)
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            }
            return null
        }

        /**
         * 解密助记词
         * @param password ByteArray  加密后的密码
         * @param mnem String      助记词
         * @return String?
         */
        fun decMenm(encPasswd: ByteArray, seed: String): String {
            try {
                val bSeed = Walletapi.hexTobyte(seed)
                val seedDecKey = Walletapi.seedDecKey(encPasswd, bSeed)
                return Walletapi.byteTostring(seedDecKey)
            } catch (e: java.lang.Exception) {
                e.printStackTrace()
            }
            return ""
        }

        //byte[]转string 16进制

        fun encodeToStrings(b: ByteArray): String {
            return Walletapi.byteTohex(b)
        }


        //1、token
        //2、coins
        fun newCoinType(
            cointype: String,
            name: String,
            platform: String?,
            treaty: String?
        ): CoinToken {
            val coinToken = CoinToken()
            coinToken.cointype = cointype
            coinToken.tokenSymbol = if (cointype == name) "" else name
            //默认都是不代扣的
            coinToken.proxy = false
            if (platform == null) {
                return coinToken
            }
            when (name) {
                Walletapi.TypeBtyString -> {
                    if (platform != "bnb") {
                        coinToken.cointype = Walletapi.TypeBtyString
                        coinToken.tokenSymbol = ""
                    }
                }
                Walletapi.TypeYccString -> {
                    if (platform == "btc" || platform == "bty" || platform == "ethereum") {
                        coinToken.cointype = Walletapi.TypeYccString
                        coinToken.tokenSymbol = ""
                    }
                }
            }
            if (cointype == "ETH" && platform != "ethereum" && platform != "ycceth") {
                coinToken.proxy = true
                if (treaty == "1") {
                    coinToken.cointype = Walletapi.TypeBtyString
                    coinToken.tokenSymbol = "$platform.$name"
                    coinToken.exer = "user.p.$platform.token"
                } else if (treaty == "2") {
                    coinToken.cointype = Walletapi.TypeBtyString
                    coinToken.tokenSymbol = "$platform.coins"
                    coinToken.exer = "user.p.$platform.coins"
                }
            }

            return coinToken
        }

        class CoinToken {
            var cointype: String = ""
            var tokenSymbol: String = ""

            //是否要代扣,默认不代扣
            var proxy: Boolean = false
            var exer: String = ""
        }


        // recover  wallet
        fun getRecoverParam(
            dctrPubKey: String,
            pubs: String,
            recoverTime: Long,
            addressId: Int,
            chainId: Int,
            dThirdPartyPubKey: String
        ): WalletRecoverParam {
            val param = WalletRecoverParam().apply {
                ctrPubKey = dctrPubKey
                recoverPubKeys = pubs
                addressID = addressId
                chainID = chainId
                relativeDelayTime = recoverTime
                thirdPartyPubKey = dThirdPartyPubKey
            }

            return param
        }


        fun queryRecover(xAddress: String, coinType: String): WalletRecoverParam {
            val r = WalletRecover()
            val walletRecoverParam = r.transportQueryRecoverInfo(QueryRecoverParam().apply {
                cointype = coinType
                tokensymbol = ""
                address = xAddress
            }, getUtil())

            return walletRecoverParam
        }
    }
}
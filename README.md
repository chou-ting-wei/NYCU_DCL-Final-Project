# NYCU_DCL-Final-Project
> 課程：113-1 Dlab  
> 組員：周廷威、林彥宇、王韋凱、許有暢

## 簡介
我們設計了一個自動販賣機系統，支持用戶選購商品並支付金額。  
物品包含水、果汁、茶、可樂，並顯示商品價格。用戶可通過按鈕或開關操作，投入 1 元、5 元、10 元或 100 元虛擬貨幣購買商品。系統會計算總支付金額，顯示選定商品並執行出貨，同時提供找零功能。此外，系統考慮了商品與現金的有限性，並支持多種類型的台幣面額支付，提供方便且智能的購物體驗。

![Main Page](https://chou-ting-wei.github.io/NYCU_DCL-Final-Project/img/img01.png)

## 操作說明
1. 按鈕
   1. usr_btn[0]：使用目前右方的選項
   2. usr_btn[1]：使用目前左方的選項
   3. usr_btn[2]：控制目前選項的數字增減
   4. usr_btn[3]：進入下一階段或重置錯誤
2. 開關
   1. usr_sw[0]：控制目前選項數字增加（1）或減少（0）
   2. usr_sw[1]：控制販賣機與背景顏色
   3. usr_sw[2]：無
   4. usr_sw[3]：盲人模式

## 功能說明
1. 基本功能
   1. 繪製自動販賣機的結構，以及標示有特定價格的水、果汁和茶
   2. 設計模擬投幣口（如視窗）來接收 10 元和 100 元台幣，並通過按鈕或開關進行控制
   3. 顯示選擇的飲料瓶可以被取出（移動到指定位置）
   4. 顯示投入的硬幣數量
   5. 設計場景需具備邊界
   6. 使用按鈕或開關控制互動
2. 進階功能
   1. 設計一個計算系統（顯示已付金額）
   2. 顯示找零金額
   3. 支援多項產品的選擇，可複選購買商品以及最多四種商品可選擇
   4. 考慮產品數量的有限性
   5. 考慮機器內現金的有限性，若機器無法找零會顯示 ERROR
   6. 增加對更多種現金面額支付
3. 額外功能
   1. 販賣機與背景安裝萬聖節濾鏡
   2. 無法超額選貨與超額支付
   3. 缺貨時架上物品會消失
   4. 付不夠金額會顯示 ERROR
   5. 物品從販賣機裡隨機掉落
   6. GREEDY 最佳化找錢演算法（$O(n)$）
   7. 即時顯示拿到多少飲料
   8. 邊框高亮提示
   9. LED 燈付款狀態高亮提示
   10. 販賣機盲人模式
   11. 選貨與付款計時功能，超時的話取消交易
   12. 換錢功能（從樓下印表機發想）

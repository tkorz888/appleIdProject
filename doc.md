FORMAT: 1A
HOST: http://store.zhangdabei.com:3000/

# 注册账号相关文档

### 上传邮箱接口 ：提供邮箱地址和密码

+ POST http://store.zhangdabei.com:3000/api/upload\_mail\_for\_new\_account

+ 发送参数

        {
            "mail": "邮箱地址",
            "mailpassword": "邮箱密码",
            "owner_id": 1,
            "secret": "xx"
        }

+ 返回结果

        {
            "code":0,
            "message":"保存成功"
        }
        
        或者
        
        {
            "code":-1,
            "message":"保存失败"
        }

### 获取一个可以注册的邮箱

+ POST http://store.zhangdabei.com:3000/api/get\_one\_mail\_to\_register

+ 发送参数

       {
           
            "owner_id": 1 ,
            "secret":"xx"
        }

+ 返回结果

        {
            "code":0,
            "message":"成功",
            "account":{
                "mail":"邮箱地址",
                "mailpassword":"邮箱密码"
            }
        }
        
       或者
       
        {
            "code":-1,
            "message":"没有可用来注册的邮箱"
        }


### 上传注册结果

+ POST http://store.zhangdabei.com:3000/api/upload\_register\_result

+ 发送参数

        {
            "success":"yes",
            "mail": "邮箱地址",
            "login": "登录账号",
            "password":"登录密码",
            "ask1":"问题1",
            "answer1":"答案1",
            "ask2":"问题2",
            "answer2":"答案2",
            "ask3":"问题3",
            "answer3":"答案3",
            "firstname":"",
            "firstname":"",
            "birthday":"生日",
            "country":"国家",
            "owner_id":1 ,
            "secret":"xx"
        }
        
        或者
        
        {
            "success":"no",
            "mail":"邮箱地址"
        }
+ 返回结果

        {
            "code":0,
            "message":"保存成功"
        }
        
       或者
       
        {
            "code":-1,
            "message":"保存成功"
        }

### 获取一个待激活的邮箱

+ POST http://store.zhangdabei.com:3000/api/get\_one\_mail\_to\_activate

+ 发送参数

       {
          "owner_id": 1 ,
          "secret":"xx"
       }

+ 返回结果

        {
            "code":0,
            "message":"成功"
            "account":{
                "login":"邮箱地址",
                "password":"邮箱密码",
                "activate_url":""
            }
        }
        
       或者
       
        {
            "code":-1,
            "message":"没有可用来注册的邮箱"
        }
        
### 上传激活结果

+ POST http://store.zhangdabei.com:3000/api/upload\_activate\_result

+ 发送参数

       	{
            "success":"yes",
            "mail":"邮箱",
            "owner_id": 1,
            "secret":"xx"
       
        }
        
       或者
       
        {
            "success":"no",
            "mail":"邮箱",
            "owner_id": 1,
            "secret":"xx"
        }


+ 返回结果

        {
            "code":0,
            "message":"保存成功"
        }
        
       或者
       
        {
            "code":-1,
            "message":"保存失败"
        }

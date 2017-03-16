FORMAT: 1A
HOST: http://store.zhangdabei.com:3000/

# 注册账号相关文档，适用于使用icloud邮箱的脚本

### 所有接口中都必须带有id和secret两个参数，这个两个参数在登录后台后右上角个人信息里能看到

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
            "id":1 ,
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

        
### 上传激活结果

+ POST http://store.zhangdabei.com:3000/api/upload\_activate\_result

+ 发送参数

       	{
            "success":"yes",
            "mail":"邮箱",
            "id": 1,
            "secret":"xx"
       
        }
        
       或者
       
        {
            "success":"no",
            "mail":"邮箱",
            "id": 1,
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

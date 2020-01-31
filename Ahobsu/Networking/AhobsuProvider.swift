//
//  AhobsuProvider.swift
//  Ahobsu
//
//  Created by admin on 2019/11/23.
//  Copyright © 2019 ahobsu. All rights reserved.
//

import Moya

struct StatusDataWrapper<S> where S: Decodable {
    var model: S
    var status: Int
    var message: String
}

class AhobsuProvider {
    static let provider = AhobsuNetworking()

    /* Common */
    
    enum StatusEnum: Int {
        
        /* Answers */
        case answers_post_success
        case answers_post_error_exist
        case answers_id_put_success
        case answers_id_delete_success
        case answers_week_get_success
        case answers_month_get_success
        case answers_date_get_success
        
        /* Missions */
        case missions_get_success
        case missions_post_success
        case missions_id_get_success
        case missions_id_put_success
        case missions_id_delete_success
        case missions_refresh_get_success
        case missions_refresh_get_error_notable
        
        /* SignIn */
        case signin_post_success
        case signin_refresh_post_success
        
        /* Users */
        case users_get_success
        case users_put_success
        case users_delete_success
        case users_delete_error_notfound
        case users_delete_error_invalid_id
        case users_refresh_put_success
        case users_my_get_success
        case users_id_get_success
        
        /* Token */
        case token_invalid
        
        func value() -> Int {
            switch (self) {
            case .answers_post_success:
                return 201
            case .answers_post_error_exist:
                return 404
            case .answers_id_put_success:
                return 200
            case .answers_id_delete_success:
                return 204
            case .answers_week_get_success:
                return 200
            case .answers_month_get_success:
                return 200
            case .answers_date_get_success:
                return 200
                
            case .missions_get_success:
                return 200
            case .missions_post_success:
                return 201
            case .missions_id_get_success:
                return 200
            case .missions_id_put_success:
                return 200
            case .missions_id_delete_success:
                return 204
            case .missions_refresh_get_success:
                return 200
            case .missions_refresh_get_error_notable:
                return 400
                
            case .signin_post_success:
                return 201
            case .signin_refresh_post_success:
                return 201
            
            case .users_get_success:
                return 200
            case .users_put_success:
                return 200
            case .users_delete_success:
                return 204
            case .users_delete_error_notfound:
                return 404
            case .users_delete_error_invalid_id:
                return 412
            case .users_refresh_put_success:
                return 200
            case .users_my_get_success:
                return 200
            case .users_id_get_success:
                return 200
                
            case .token_invalid:
                return 1100
            }
        }
    }
    
    static let updateRefreshToken: (StatusDataWrapper<Token>?) -> Void = { wrapper in
        guard let refreshToken = wrapper?.model else {
            /* refreshToken 받아오기 실패 */
            return
        }
        
        TokenManager.sharedInstance.registerAccessToken(token: refreshToken.accessToken,
                                                        completion: nil,
                                                        error: nil)
        
        TokenManager.sharedInstance.registerRefreshToken(token: refreshToken.refreshToken,
                                                         completion: nil,
                                                         error: nil)
    }
    
    class func updateRefreshTokenOrLogin<S: Decodable>(_ response: Response,
                                                       _ completion: @escaping (StatusDataWrapper<S>?) -> Void,
                                                       _ expireTokenAction: @escaping () -> Void) -> Void {
        if let data = try? response.map(APIData<S>.self) {
            let status = data.status
            let message = data.message
            let model = data.data
            
            if (status == StatusEnum.value(.token_invalid)()) {
                /* Refresh Token 만료 */
                expireTokenAction()
                return
            }
            
            return completion(StatusDataWrapper(model: model, status: status, message: message))
        }
        
        return completion(nil)
    }
    
    class func statusDataOrNil<S: Decodable>(_ response: Response,
                                             _ completion: @escaping ((StatusDataWrapper<S>?) -> Void),
                                             _ expireTokenAction: @escaping () -> Void) where S: Decodable {
        if let data = try? response.map(APIData<S>.self) {
            let status = data.status
            let message = data.message
            let model = data.data
            
            if (status == StatusEnum.value(.token_invalid)()) {
                /* Access Token 만료 */
                AhobsuProvider.refreshToken(completion: updateRefreshToken,
                                            error: { error in
                                                /* Handling error */
                                            },
                                            expireTokenAction: {
                                                expireTokenAction()
                })
            }
            
            return completion(StatusDataWrapper(model: model, status: status, message: message))
        }
        
        return completion(nil)
    }
    
    /* Answers */

    class func registerAnswer(missionId: Int,
                              contentOrNil: String?,
                              imageOrNil: UIImage?,
                              completion: @escaping ((Response) -> Void),
                              error: @escaping ((MoyaError) -> Void)) {
        provider.request(.registerAnswer(missionId: missionId,
                                         contentOrNil: contentOrNil,
                                         imageOrNil: imageOrNil),
                         completionHandler: completion,
                         errorHandler: error)
    }

    class func updateAnswer(answerId: Int,
                            contentOrNil: String?,
                            imageOrNil: UIImage?,
                            completion: @escaping ((Response) -> Void),
                            error: @escaping ((MoyaError) -> Void)) {
        provider.request(.updateAnswer(answerId: answerId,
                                       contentOrNil: contentOrNil,
                                       imageOrNil: imageOrNil),
                        completionHandler: completion,
                        errorHandler: error)
    }

    class func getWeekAnswer(mondayDate: String,
                             completion: @escaping ((Response) -> Void),
                             error: @escaping ((MoyaError) -> Void)) {
        provider.request(.getWeekAnswers(mondayDate: mondayDate),
                         completionHandler: completion,
                         errorHandler: error)
    }

    class func getAnswer(missionDate: String,
                         completion: @escaping ((Response) -> Void),
                         error: @escaping ((MoyaError) -> Void)) {
        provider.request(.getAnswer(missionDate: missionDate),
                         completionHandler: completion,
                         errorHandler: error)
    }
    
    class func getAnswersWeek(completion: @escaping ((Response) -> Void),
                         error: @escaping ((MoyaError) -> Void)) {
        provider.request(.getAnswersWeek,
                         completionHandler: completion,
                         errorHandler: error)
    }

    /* Missions */

    class func getMission(completion: @escaping ((StatusDataWrapper<Mission>?) -> Void),
                          error: @escaping ((MoyaError) -> Void),
                          expireTokenAction: @escaping () -> Void) {
        provider.request(.getMission,
                         completionHandler: { response in
                            self.statusDataOrNil(response,
                                                 completion,
                                                 expireTokenAction)
                        },
                         errorHandler: error)
    }

    class func refreshMission(completion: @escaping ((StatusDataWrapper<Mission>?) -> Void),
                              error: @escaping ((MoyaError) -> Void),
                              expireTokenAction: @escaping () -> Void) {
        provider.request(.refreshMission,
                        completionHandler: { response in
                            self.statusDataOrNil(response,
                                                 completion,
                                                 expireTokenAction)
                        },
                        errorHandler: error)
    }

    /* SignIn */

    class func signIn(snsId: String,
                      auth: String,
                      completion: @escaping ((StatusDataWrapper<Token>?) -> Void),
                      error: @escaping ((MoyaError) -> Void),
                      expireTokenAction: @escaping () -> Void) {
        provider.request(.signIn(snsId: snsId, auth: auth),
                         completionHandler: { response in
                            self.statusDataOrNil(response,
                                                 completion,
                                                 expireTokenAction)
                         },
                         errorHandler: error)
    }

    /* Token */

    class func refreshToken(completion: @escaping ((StatusDataWrapper<Token>?) -> Void),
                            error: @escaping ((MoyaError) -> Void),
                            expireTokenAction: @escaping () -> Void) {
        provider.request(.refreshToken,
                         completionHandler: { response in
                            self.updateRefreshTokenOrLogin(response,
                                                           completion,
                                                           expireTokenAction)
                         },
                         errorHandler: error)
    }

    /* Users */

    class func updateProfile(user: User,
                             completion: @escaping ((StatusDataWrapper<User>?) -> Void),
                             error: @escaping ((MoyaError) -> Void),
                             expireTokenAction: @escaping () -> Void) {
        provider.request(.updateProfile(name: user.name,
                                        birthday: user.birthday,
                                        email: user.email,
                                        gender: user.gender),
                        completionHandler: { response in
                            self.statusDataOrNil(response,
                                                 completion,
                                                 expireTokenAction)
                        },
                        errorHandler: error)
    }

    class func deleteProfile(completion: @escaping ((StatusDataWrapper<User>?) -> Void),
                             error: @escaping ((MoyaError) -> Void),
                             expireTokenAction: @escaping () -> Void) {
        provider.request(.deleteProfile,
                         completionHandler: { response in
                            self.statusDataOrNil(response,
                                                 completion,
                                                 expireTokenAction)
                         },
                         errorHandler: error)
    }

    class func getProfile(completion: @escaping ((StatusDataWrapper<User>?) -> Void),
                          error: @escaping ((MoyaError) -> Void),
                          expireTokenAction: @escaping () -> Void) {
        provider.request(.getProfile,
                         completionHandler: { response in
                            self.statusDataOrNil(response,
                                                 completion,
                                                 expireTokenAction)
                         },
                         errorHandler: error)
    }
}

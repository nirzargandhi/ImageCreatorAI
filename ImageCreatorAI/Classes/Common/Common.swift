//
//  Common.swift
//  ImageCreatorAI
//
//  Created by Nirzar Gandhi on 16/05/25.
//

import Foundation
import UIKit


// MARK: - UI / Device Related Functions
func getStoryBoard(identifier: String, storyBoardName: String) -> UIViewController {
    return UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: identifier)
}

func getBottomSafeAreaHeight() -> CGFloat {
    return (UIDevice.current.hasNotch == true) ? (WINDOWSCENE?.windows.first?.safeAreaInsets.bottom ?? 0) : 0
}

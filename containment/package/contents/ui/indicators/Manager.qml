/*
*  Copyright 2019 Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of Latte-Dock
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.7

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.latte 0.2 as Latte

import "options" as Options
import "../applet/indicator" as AppletIndicator

Item{
    id: managerIndicator

    readonly property Item common: commonOptions
    readonly property Item explicit: explicitOptions.item

    readonly property Component plasmaStyleComponent: plasmaStyleIndicator

    readonly property Component indicatorComponent: {
        switch (indicators.common.indicatorStyle) {
        case Latte.Types.LatteIndicator:
            return latteStyleIndicator;
        case Latte.Types.PlasmaIndicator:
            return plasmaStyleIndicator;
        case Latte.Types.UnityIndicator:
            return unityStyleIndicator;
        default:
            return latteStyleIndicator;
        };
    }

    readonly property Item info: Item{
        readonly property bool needsIconColors: metricsLoader.active && metricsLoader.item && metricsLoader.item.hasOwnProperty("needsIconColors")
                                                && metricsLoader.item.needsIconColors
        readonly property bool providesFrontLayer: metricsLoader.active && metricsLoader.item && metricsLoader.item.hasOwnProperty("providesFrontLayer")
                                                   && metricsLoader.item.providesFrontLayer

        readonly property int extraMaskThickness: {
            if (metricsLoader.active && metricsLoader.item && metricsLoader.item.hasOwnProperty("extraMaskThickness")) {
                return metricsLoader.item.extraMaskThickness;
            }

            return 0;
        }
    }


    Options.Common {
        id: commonOptions
    }

    Loader{
        id: explicitOptions
        active: true
        source: {
            if (commonOptions.indicatorStyle === Latte.Types.LatteIndicator) {
                return "options/Latte.qml";
            } else if (commonOptions.indicatorStyle === Latte.Types.PlasmaIndicator) {
                return "options/Plasma.qml";
            }

            return "options/Latte.qml";
        }
    }

    //! Indicators Components
    Component {
        id: latteStyleIndicator
        Latte.LatteIndicator{}
    }

    Component {
        id: plasmaStyleIndicator
        Latte.PlasmaIndicator{}
    }

    Component{
        id:unityStyleIndicator
        Latte.UnityIndicator{}
    }

    //! Metrics and values provided from an invisible indicator
    Loader{
        id: metricsLoader
        opacity: 0

        readonly property bool isBackLayer: true
        readonly property Item manager: AppletIndicator.Manager{
            appletIsValid: false
        }

        sourceComponent: managerIndicator.indicatorComponent
    }
}

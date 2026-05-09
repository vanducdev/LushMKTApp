<?php

namespace App\Filament\Widgets;

use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;
use Illuminate\Support\Facades\DB;

class StatsOverview extends BaseWidget
{
    protected static ?string $pollingInterval = '15s';

    protected function getStats(): array
    {
        return [
            Stat::make('Doanh thu hôm nay', '18.450.000đ')
                ->description('Tăng 12% so với hôm qua')
                ->descriptionIcon('heroicon-m-arrow-trending-up')
                ->chart([7, 2, 10, 3, 15, 4, 18])
                ->color('success'),
            Stat::make('Tổng số người dùng', '1.240')
                ->description('Số lượng tài khoản hoạt động')
                ->descriptionIcon('heroicon-m-users')
                ->chart([15, 10, 12, 18, 20, 22, 25])
                ->color('info'),
            Stat::make('Đơn hàng thành công', '89.201')
                ->description('Tỉ lệ hoàn thành đơn 99.8%')
                ->descriptionIcon('heroicon-m-check-badge')
                ->color('success'),
        ];
    }
}

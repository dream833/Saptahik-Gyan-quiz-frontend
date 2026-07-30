import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:path_provider/path_provider.dart';

import '../../../../data/config/appcolor.dart';
import '../../../../data/config/app_cons.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    this.title = 'PDF Viewer',
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? _localPath;
  bool _isDownloading = true;
  double _downloadProgress = 0.0;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  Future<void> _downloadPdf() async {
    try {
      String url = widget.pdfUrl;
      if (!url.startsWith('http')) {
        url = '$BASE_URL/$url';
      }

      final dir = await getTemporaryDirectory();
      final fileName = 'pyq_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final savePath = '${dir.path}/$fileName';

      final dio = DIO.Dio();
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );

      setState(() {
        _localPath = savePath;
        _isDownloading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to download PDF. Please try again.';
        _isDownloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColor.cardColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColor.backgroundColorLight,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.close_rounded,
              color: AppColor.textPrimary,
              size: 22.sp,
            ),
          ),
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isDownloading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60.r,
              height: 60.r,
              child: CircularProgressIndicator(
                value: _downloadProgress > 0 ? _downloadProgress : null,
                strokeWidth: 4,
                color: AppColor.buttonOneColor,
                backgroundColor: AppColor.shimmerBase,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              _downloadProgress > 0
                  ? 'Downloading... ${(_downloadProgress * 100).toStringAsFixed(0)}%'
                  : 'Downloading PDF...',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColor.textSecondary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Please wait while the file loads',
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                color: AppColor.textLight,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: AppColor.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  color: AppColor.error,
                  size: 48.sp,
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Failed to load PDF',
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: AppColor.textSecondary,
                ),
              ),
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isDownloading = true;
                    _downloadProgress = 0.0;
                    _errorMessage = '';
                    _localPath = null;
                  });
                  _downloadPdf();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.buttonOneColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_localPath != null) {
      return PDFView(
        filePath: _localPath!,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: true,
        pageFling: true,
        onRender: (_) {},
        onError: (error) {
          setState(() {
            _errorMessage = error.toString();
          });
        },
        onPageError: (_, __) {},
        onViewCreated: (_) {},
      );
    }

    return const SizedBox.shrink();
  }
}

package com.insurance.atpl.altruist_secure_flutter.RetroFitApi;

import java.io.Serializable;

public class DamageScreenStatus  implements Serializable {


    /**
     * statusDescription : {"errorCode":200,"errorMessage":"Success"}
     * deviceDetailsUploads : {"id":33,"userId":262,"uploadType":"damaged_screen","status":"0","uploadDateTime":1593757121000}
     */

    private StatusDescriptionBean statusDescription;
    private DeviceDetailsUploadsBean deviceDetailsUploads;

    public StatusDescriptionBean getStatusDescription() {
        return statusDescription;
    }

    public void setStatusDescription(StatusDescriptionBean statusDescription) {
        this.statusDescription = statusDescription;
    }

    public DeviceDetailsUploadsBean getDeviceDetailsUploads() {
        return deviceDetailsUploads;
    }

    public void setDeviceDetailsUploads(DeviceDetailsUploadsBean deviceDetailsUploads) {
        this.deviceDetailsUploads = deviceDetailsUploads;
    }

    public static class StatusDescriptionBean {
        /**
         * errorCode : 200
         * errorMessage : Success
         */

        private int errorCode;
        private String errorMessage;

        public int getErrorCode() {
            return errorCode;
        }

        public void setErrorCode(int errorCode) {
            this.errorCode = errorCode;
        }

        public String getErrorMessage() {
            return errorMessage;
        }

        public void setErrorMessage(String errorMessage) {
            this.errorMessage = errorMessage;
        }
    }

    public static class DeviceDetailsUploadsBean {
        /**
         * id : 33
         * userId : 262
         * uploadType : damaged_screen
         * status : 0
         * uploadDateTime : 1593757121000
         */

        private int id;
        private int userId;
        private String uploadType;
        private String status;
        private long uploadDateTime;

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public int getUserId() {
            return userId;
        }

        public void setUserId(int userId) {
            this.userId = userId;
        }

        public String getUploadType() {
            return uploadType;
        }

        public void setUploadType(String uploadType) {
            this.uploadType = uploadType;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public long getUploadDateTime() {
            return uploadDateTime;
        }

        public void setUploadDateTime(long uploadDateTime) {
            this.uploadDateTime = uploadDateTime;
        }
    }
}
